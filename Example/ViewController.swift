//
//  ViewController.swift
//  EasyStepIndicator
//
//  Created by pengzishang on 2019/10/16.
//  Copyright © 2019 pengzishang. All rights reserved.
//

import UIKit


class ViewController: UIViewController , EasyStepIndicatorDataSource ,EasyStepIndicatorDelegate{
    func didChangeStep(indicator: EasyStepIndicator, index: Int) {
        
    }
    
    func stepConfigForStep(indicator: EasyStepIndicator, index: Int, config: inout StepConfig){
        if index == 2{
            config.radius = 30
        }
        if index == 3 {
            config.titleMargin = 20
            config.stepText.fontSize = 30
        }
    }
    
    func lineConfigForProcess(indicator: EasyStepIndicator, index: Int, config:inout LineConfig){
    }
    
    func titleConfigForStep(indicator: EasyStepIndicator, index: Int, config:inout TitleConfig){
    }
    
    func shouldStepLineFitDescriptionText() -> Bool {
        true
    }
    
    func characterForStep(indicator: EasyStepIndicator, index: Int) -> String {
        return "abc"
    }
    
    func titleForStep(indicator: EasyStepIndicator, index: Int) -> String {
        return["Yours faithfully", " This is to introduce Mr. Frank Jones, our new marketing specialist who will be in London from April 5 to mid April on business. We are pleased to introduce Mr. Wang You, our import manager of Textiles Department. Mr. Wang is spending three weeks in your city to develop our business with chief manufactures and to make purchases of decorative fabrics for the coming season.We shall be most grateful if you will introduce him to reliable manufacturers and give him any help or advice he may need.", "Track progress", "Finishes\ninvestigation\nFinishes\ninvestigation\nFinishes\ninvestigation\nFinishes\ninvestigation"][index]
        return ["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation","Finishes\ninvestigation"][index]
    }

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var indicator: EasyStepIndicator!
    @IBOutlet weak var currentStep: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.dataSource = self
        self.indicator.delegate = self
        self.indicator.alignmentMode = .top
        stepper.maximumValue = Double(indicator.numberOfSteps - 1)
        setState(step: 0)

    }

    fileprivate func setState(step: Int) {
        currentStep.text = String(step)
        indicator.currentStep = step
    }

    @IBAction func didChangeValue(_ sender: UIStepper) {
        setState(step: Int(sender.value))
    }

}

