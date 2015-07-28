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

    func reset() {
        gradientView.reverse = false
        gradientView.slopeFactor = 2.0
        slider.value = Float(pow(M_E, 2.0))
        updateLabel()
    }

    func updateLabel() {
        factorLabel.text = String(format: "Slope factor: %0.4fx", gradientView.slopeFactor)
    }

    @IBAction func factorChanged(sender: UISlider) {
        gradientView.slopeFactor = CGFloat(logf(sender.value))
        updateLabel()
    }

    @IBAction func reset(sender: AnyObject) {
        reset()
    }

    @IBAction func invert(sender: AnyObject) {
        gradientView.reverse = !gradientView.reverse
    }
}

