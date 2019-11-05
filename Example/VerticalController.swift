//
//  VerticalController.swift
//  EasyStepIndicator
//
//  Created by pengzishang on 2019/10/23.
//  Copyright © 2019 pengzishang. All rights reserved.
//

import UIKit

class VerticalController: UIViewController,EasyStepIndicatorDataSource {
    
    func characterForStep(indicator: EasyStepIndicator, index: Int) -> String {
        return "a"
    }
    
    func titleForStep(indicator: EasyStepIndicator, index: Int) -> String {
//        return ["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation","Finishes\ninvestigation"][index]
        return["Yours faithfully", " This is to introduce Mr. Frank Jones, our new marketing specialist who will be in London from April 5 to mid April on business. We are pleased to introduce Mr. Wang You, our import manager of Textiles Department. Mr. Wang is spending three weeks in your city to develop our business with chief manufactures and to make purchases of decorative fabrics for the coming season.We shall be most grateful if you will introduce him to reliable manufacturers and give him any help or advice he may need.", "Track progress", "Finishes\ninvestigation\nFinishes\ninvestigation\nFinishes\ninvestigation\nFinishes\ninvestigation"][index]
    }
    
    

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var indicator: EasyStepIndicator!
    @IBOutlet weak var currentStep: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.dataSource = self
        stepper.maximumValue = Double(indicator.numberOfSteps - 1)
        setState(step: 0)
//        indicator.stepLineFitDescriptionText = true
//        self.indicator.stepDescriptionTexts = ["Yours faithfully", " This is to introduce Mr. Frank Jones, our new marketing specialist who will be in London from April 5 to mid April on business. We are pleased to introduce Mr. Wang You, our import manager of Textiles Department. Mr. Wang is spending three weeks in your city to develop our business with chief manufactures and to make purchases of decorative fabrics for the coming season.We shall be most grateful if you will introduce him to reliable manufacturers and give him any help or advice he may need.", "Track progress", "Finishes\ninvestigation\nFinishes\ninvestigation\nFinishes\ninvestigation\nFinishes\ninvestigation\n"]//圆下的描述文字
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
