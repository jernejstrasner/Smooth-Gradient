// The MIT License (MIT)
//
// Copyright (c) 2014 Jernej Strasner
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

public class GradientView: UIView {

    @IBInspectable public var slopeFactor: CGFloat = 2.0 {
        didSet {
            setupShadingFunction()
            setNeedsDisplay()
        }
    }

    @IBInspectable public var mirror: Bool = false {
        didSet {
            setupShadingFunction()
            setNeedsDisplay()
        }
    }

    @IBInspectable public var startColor = UIColor.whiteColor() {
        didSet {
            startColorComponents = Color(color: startColor)
            setupShadingFunction()
            setNeedsDisplay()
        }
    }

    @IBInspectable public var endColor = UIColor.darkGrayColor() {
        didSet {
            endColorComponents = Color(color: endColor)
            setupShadingFunction()
            setNeedsDisplay()
        }
    }

    @IBInspectable public var drawsBeforeStart: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var drawsAfterEnd: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    private let colorSpace = CGColorSpaceCreateDeviceRGB()
    private var startColorComponents = Color(color: UIColor.whiteColor())
    private var endColorComponents = Color(color: UIColor.darkGrayColor())

    private let shadingFunctionInfo = UnsafeMutablePointer<FunctionInfo>.alloc(1)
    private var shadingFunction: CGFunction!

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Make sure view redraws on when bounds change
        contentMode = .Redraw
        // Prepare the shading function
        setupShadingFunction()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        // Make sure view redraws on when bounds change
        contentMode = .Redraw
        // Prepare the shading function
        setupShadingFunction()
    }

    deinit {
        shadingFunctionInfo.dealloc(1)
    }

    private func setupShadingFunction() {
        // Data to pass to shading function
        shadingFunctionInfo.memory = FunctionInfo(
            startColor: mirror ? endColorComponents : startColorComponents,
            endColor: mirror ? startColorComponents : endColorComponents,
            slopeFactor: slopeFactor
        )

        // Create the function callbacks
        var callbacks = CGFunctionCallbacks(version: 0, evaluate: performShading, releaseInfo: nil)

        // As input to our function we want 1 value in the range [0.0, 1.0].
        // This is our position within the gradient.
        let domainDimension = 1
        let domain: [CGFloat] = [0.0, 1.0]

        // The output of our shading function are 4 values, each in the range [0.0, 1.0].
        // By specifying 4 ranges here, we limit each color component to that range. Values outside of the range get clipped.
        let rangeDimension = 4
        let range: [CGFloat] = [
            0.0, 1.0, // R
            0.0, 1.0, // G
            0.0, 1.0, // B
            0.0, 1.0  // A
        ]
        
        // Create the shading function
        shadingFunction = CGFunctionCreate(shadingFunctionInfo, domainDimension, domain, rangeDimension, range, &callbacks)
    }

    override public func drawRect(rect: CGRect) {
        // Get the context
        let context = UIGraphicsGetCurrentContext()

        // Start and ending points
        let startPoint = CGPoint(x: 1, y: 0)
        let endPoint = CGPoint(x: 1, y: rect.size.height)

        // Create the shading object
        let shading = CGShadingCreateAxial(colorSpace, startPoint, endPoint, shadingFunction, drawsBeforeStart, drawsAfterEnd)

        // Draw
        CGContextDrawShading(context, shading)
    }

}

private struct Color {
    var r: CGFloat = 1
    var g: CGFloat = 1
    var b: CGFloat = 1
    var a: CGFloat = 1

    init(color: UIColor) {
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
    }
}

private struct FunctionInfo {
    var startColor: Color
    var endColor: Color
    var slopeFactor: CGFloat
}

private func performShading(infoPtr: UnsafeMutablePointer<Void>, inData: UnsafePointer<CGFloat>, outData: UnsafeMutablePointer<CGFloat>) -> Void {
    let info = UnsafeMutablePointer<FunctionInfo>(infoPtr).memory
    let position = inData[0]
    let p = pow(position, info.slopeFactor)
    let q = p/(p + pow(1.0-position, info.slopeFactor))
    outData[0] = info.startColor.r + (info.endColor.r - info.startColor.r) * q
    outData[1] = info.startColor.g + (info.endColor.g - info.startColor.g) * q
    outData[2] = info.startColor.b + (info.endColor.b - info.startColor.b) * q
    outData[3] = info.startColor.a + (info.endColor.a - info.startColor.a) * q
}
