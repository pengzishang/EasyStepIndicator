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
    @IBOutlet weak var alignmentSegment: UISegmentedControl!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var directSegment: UISegmentedControl!
    @IBOutlet weak var minContentMargin: UIStepper!
    @IBOutlet weak var minContentLab: UILabel!
    @IBOutlet weak var maxContentWidthLabel: UILabel!
    @IBOutlet weak var maxContentWidthStepper: UIStepper!
    
    
    var shouldStepLineFitText = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.dataSource = self
        self.indicator.delegate = self
        self.indicator.alignmentMode = .top
        alignmentSegment.selectedSegmentIndex = 0
        minContentMargin.value = Double(self.indicator.minContentMargin)
        minContentLab.text = "\(self.indicator.minContentMargin)"
        self.maxContentWidthLabel.text = self.indicator.maxContentWidth == CGFloat.greatestFiniteMagnitude ? "Unlimit" : "\(self.indicator.maxContentWidth)"
        
        switcher.isOn = shouldStepLineFitText
        self.indicator.freezeZone = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 20)
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
    
    @IBAction func changeAlignmentSegmentValue(_ sender: UISegmentedControl) {
        indicator.alignmentMode = [AlignmentMode.top,AlignmentMode.center][sender.selectedSegmentIndex]
    }
    
    @IBAction func didDirectSegmentValueChange(_ sender: UISegmentedControl) {
        self.indicator.direction = [Direction.leftToRight,Direction.rightToLeft,Direction.topToBottom,Direction.bottomToTop][sender.selectedSegmentIndex]
    }
    
    @IBAction func changeSwitchValue(_ sender: UISwitch) {
        self.shouldStepLineFitText = sender.isOn
        indicator.reload()
    }
    
    @IBAction func changeContentMarginValue(_ sender: UIStepper) {
        self.indicator.minContentMargin = CGFloat(sender.value)
        minContentLab.text = "\(self.indicator.minContentMargin)"
    }
    
    @IBAction func maxContentWidthStepperValueChange(_ sender: UIStepper) {
        self.maxContentWidthLabel.text = sender.value == 0 ? "Unlimit" : "\(sender.value)"
        self.indicator.maxContentWidth = sender.value == 0 ? CGFloat.greatestFiniteMagnitude : CGFloat(sender.value)
    }
    
    func randomColor() -> UIColor {
        return UIColor.init(red:CGFloat(arc4random_uniform(255))/CGFloat(255.0), green:CGFloat(arc4random_uniform(255))/CGFloat(255.0), blue:CGFloat(arc4random_uniform(255))/CGFloat(255.0) , alpha: 1)
    }
}


extension HorizontalController:EasyStepIndicatorDataSource {
    
    func viewForProcess(indicator: EasyStepIndicator, index: Int) -> UIView? {
        return nil
    }
    
    func oppositeViewForStep(indicator: EasyStepIndicator, index: Int) -> UIView? {
        return nil
    }
    
    func characterForStep(indicator: EasyStepIndicator, index: Int) -> String {
        return "\(index)"
//        ["A","B","C","D"][index]
    }
    
    func titleForStep(indicator: EasyStepIndicator, index: Int) -> String {
//        return "TTT"
        "This is to introduce Mr. Frank J,O our new marketing specialist who will be in London from April 5 to mid April on business.  "
//        [ "This is to introduce Mr. Frank J,O our new marketing specialist who will be in London from April 5 to mid April on business.  ","This is to introduce Mr. Frank J,O our new marketing specialist who will be in London from April 5 to mid April on business.  ", "This is to introduce Mr. Frank J,O our new marketing specialist who will be in London from April 5 to mid April on business.  ", "This is to introduce Mr. Frank J,O our new marketing specialist who will be in London from April 5 to mid April on business.  "][index]
//        ["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation","Finishes\ninvestigation"][index]
    }
    
}

extension HorizontalController:EasyStepIndicatorDelegate {
    func stepConfigForStep(indicator: EasyStepIndicator, index: Int, config: inout StepConfig){
        if index == 2{
//            config.radius = 40
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
        return self.shouldStepLineFitText
    }
    
    func didChangeStep(indicator: EasyStepIndicator, index: Int) {
        
    }
    
}

