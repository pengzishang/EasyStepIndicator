//
//  ViewController.swift
//  EasyStepIndicator
//
//  Created by pengzishang on 2019/10/16.
//  Copyright © 2019 pengzishang. All rights reserved.
//

import UIKit


class ViewController: UIViewController {


    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var indicator: EasyStepIndicator!
    @IBOutlet weak var currentStep: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.maximumValue = Double(indicator.numberOfSteps - 1)
        setState(step: 0)

//        indicator.stepCircleTexts = []
        indicator.stepCircleTexts = ["A", "B", "C", "D"]
        indicator.stepDescriptionTexts = ["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation"]
    }

    fileprivate func setState(step: Int) {
        currentStep.text = String(step)
        indicator.currentStep = step
    }

    @IBAction func didChangeValue(_ sender: UIStepper) {
        setState(step: Int(sender.value))
    }

}

