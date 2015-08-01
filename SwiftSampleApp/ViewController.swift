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
import SmoothGradient

class ViewController: UIViewController {

    @IBOutlet weak var gradientView: JSTGradientView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var factorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        reset()
    }

    func updateLabel() {
        factorLabel.text = String(format: "Slope factor: %0.4fx", gradientView.interpolationFactor)
    }

    @IBAction func factorChanged(sender: UISlider) {
        gradientView.interpolationFactor = CGFloat(logf(sender.value))
        updateLabel()
    }

    @IBAction func reset() {
        gradientView.startPoint = CGPoint(x: 0.5, y: 0)
        gradientView.endPoint = CGPoint(x: 0.5, y: 1)
        gradientView.interpolationFactor = 2.0
        slider.value = Float(pow(M_E, 2.0))
        updateLabel()
    }

    @IBAction func invert() {
        swap(&gradientView.startPoint, &gradientView.endPoint)
    }
}

