//
//  ViewController.swift
//  SwiftSampleApp
//
//  Created by Jernej Strasner on 7/28/15.
//  Copyright (c) 2015 Jernej Strasner. All rights reserved.
//

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

