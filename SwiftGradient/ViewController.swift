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

class ViewController: UIViewController {

    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var factorLabel: UILabel!

    @IBAction func reset() {
        gradientView.startPoint = CGPoint(x: 0.5, y: 0)
        gradientView.endPoint = CGPoint(x: 0.5, y: 1)
        gradientView.slopeFactor = 2.0
        slider.value = Float(pow(M_E, 2.0))
        updateLabel()
    }

    @IBAction func toggleMirror() {
        swap(&gradientView.startPoint, &gradientView.endPoint)
    }

    @IBAction func sliderChanged(sender: UISlider) {
        gradientView.slopeFactor = CGFloat(logf(sender.value))
        updateLabel()
    }

    func updateLabel() {
        factorLabel.text = String(format: "Slope factor: %0.4fx", gradientView.slopeFactor)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gradientView.endColor = UIColor(red: 0, green: 0, blue: 128.0/255.0, alpha: 1)
        reset()
    }

}

