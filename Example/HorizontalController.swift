//
//  HorizontalController.swift
//  EasyStepIndicator
//
//  Created by pengzishang on 2019/11/6.
//  Copyright © 2019 pengzishang. All rights reserved.
//

import UIKit

class HorizontalController: UIViewController {
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var indicator: EasyStepIndicator!
    @IBOutlet weak var currentStep: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.dataSource = self
        self.indicator.delegate = self
        self.indicator.alignmentMode = .center
//        self.indicator.freezeZone = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 20)
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
    
    func randomColor() -> UIColor {
        return UIColor.init(red:CGFloat(arc4random_uniform(255))/CGFloat(255.0), green:CGFloat(arc4random_uniform(255))/CGFloat(255.0), blue:CGFloat(arc4random_uniform(255))/CGFloat(255.0) , alpha: 1)
    }
}

extension HorizontalController:EasyStepIndicatorDataSource {
    func characterForStep(indicator: EasyStepIndicator, index: Int) -> String {
        ["A","B","C","D"][index]
    }
    
    func titleForStep(indicator: EasyStepIndicator, index: Int) -> String {
        ["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation","Finishes\ninvestigation"][index]
    }
    
}

extension HorizontalController:EasyStepIndicatorDelegate {
    func stepConfigForStep(indicator: EasyStepIndicator, index: Int, config: inout StepConfig){
        if index == 2{
            config.radius = 30
        }
        if index == 3 {
            config.titleMargin = 20
            config.stepText.fontSize = 30
        }
        config.stepText.colors.complete = randomColor()
        config.stepText.colors.incomplete = randomColor()
        config.annular.colors.complete = randomColor()
        config.annular.colors.incomplete = randomColor()
        config.tint.colors.complete = randomColor()
        config.tint.colors.incomplete = randomColor()
    }
    
    func lineConfigForProcess(indicator: EasyStepIndicator, index: Int, config:inout LineConfig){
        config.colors.complete = randomColor()
        config.colors.incomplete = randomColor()
    }
    
    func titleConfigForStep(indicator: EasyStepIndicator, index: Int, config:inout TitleConfig){
        config.colors.complete = randomColor()
        config.colors.incomplete = randomColor()
    }
    
    func shouldStepLineFitDescriptionText() -> Bool {
        false
    }
    
    func didChangeStep(indicator: EasyStepIndicator, index: Int) {
        
    }
    
}

