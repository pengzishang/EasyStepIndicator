//
//  VerticalController.swift
//  EasyStepIndicator
//
//  Created by pengzishang on 2019/10/23.
//  Copyright © 2019 pengzishang. All rights reserved.
//

import UIKit

class VerticalController: UIViewController {

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var indicator: EasyStepIndicator!
    @IBOutlet weak var currentStep: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.maximumValue = Double(indicator.numberOfSteps - 1)
        setState(step: 0)
//            indicator.stepLineFitDescriptionText = true
        self.indicator.stepDescriptionTexts = ["Alarm\ntriggeredAlarm\ntriggeredAlarm\ntriggeredAlarm\ntriggered", "Dispatchna guardna guardna guardna guardna guardna guardna guardna guardna guardestigationFinisheestigationFinisheestigationFinishe", "Track\nprogress", "Finishes\ninvestigationFinishes\ninvestigationFinishes\ninvestigationFinishes\ninvestigationFinishes\ninvestigation"]//圆下的描述文字
    }
    
    fileprivate func setState(step: Int) {
        currentStep.text = String(step)
        indicator.currentStep = step
    }
    
    @IBAction func didChangeValue(_ sender: UIStepper) {
        setState(step: Int(sender.value))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
