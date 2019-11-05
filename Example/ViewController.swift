//
//  ViewController.swift
//  EasyStepIndicator
//
//  Created by pengzishang on 2019/10/16.
//  Copyright © 2019 pengzishang. All rights reserved.
//

import UIKit


class ViewController: UIViewController , EasyStepIndicatorDataSource {
    func characterForStep(indicator: EasyStepIndicator, index: Int) -> String {
        return "a"
    }
    
    func titleForStep(indicator: EasyStepIndicator, index: Int) -> String {
        return ["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation","Finishes\ninvestigation"][index]
    }
    


    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var indicator: EasyStepIndicator!
    @IBOutlet weak var currentStep: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.dataSource = self
        stepper.maximumValue = Double(indicator.numberOfSteps - 1)
        setState(step: 0)

//        indicator.stepCircleTexts = []
//        indicator.stepCircleTexts = ["A", "B", "C", "D"]
//        indicator.stepDescriptionTexts = ["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation"]
    }

    fileprivate func setState(step: Int) {
        currentStep.text = String(step)
        indicator.currentStep = step
    }

    @IBAction func didChangeValue(_ sender: UIStepper) {
        setState(step: Int(sender.value))
    }

}

