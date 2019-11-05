//
//  HorizontalCodeController.swift
//  EasyStepIndicator
//
//  Created by pengzishang on 2019/10/17.
//  Copyright © 2019 pengzishang. All rights reserved.
//

import UIKit

class HorizontalCodeController: UIViewController, EasyStepIndicatorDataSource ,EasyStepIndicatorDelegate{

        func didChangeStep(indicator: EasyStepIndicator, index: Int) {
            
        }
        
        func stepConfigForStep(indicator: EasyStepIndicator, index: Int, config: inout StepConfig) -> StepConfig {
            config.radius = 30
            config.stepText.colors.complete = UIColor.white
            config.stepText.colors.incomplete = UIColor.black
            config.tint.colors.complete = UIColor.systemBlue
            config.tint.colors.incomplete = UIColor.gray
            config.annular.dashPatternComplete.margin = 0
            config.annular.dashPatternComplete.width = 0
            config.annular.dashPatternIncomplete.margin = 0
            config.annular.dashPatternIncomplete.width = 0
            config.annular.colors.complete = UIColor.brown
            config.annular.colors.incomplete = UIColor.orange
            config.annular.strokeWidth = 3
            if index == 3 {
                config.radius = 20
                config.titleMargin = 20
                config.stepText.fontSize = 30
            }
            return config
        }
        
        func lineConfigForProcess(indicator: EasyStepIndicator, index: Int, config:inout LineConfig) -> LineConfig {
            config.colors.complete = UIColor.brown
            config.colors.incomplete = UIColor.orange
            config.dashPatternComplete.margin = 0
            config.dashPatternComplete.width = 0
            return config
        }
        
        func titleConfigForStep(indicator: EasyStepIndicator, index: Int, config:inout TitleConfig) -> TitleConfig {
            if index == 0 {
                config.title.fontSize = 12
                config.colors.complete = UIColor.brown
                config.colors.incomplete = UIColor.systemRed
            }
            return config
        }
        
        func shouldStepLineFitDescriptionText() -> Bool {
            true
        }
        
        func characterForStep(indicator: EasyStepIndicator, index: Int) -> String {
            return "ab"
        }
        
        func titleForStep(indicator: EasyStepIndicator, index: Int) -> String {
    //        return["Yours faithfully", " This is to introduce Mr. Frank Jones, our new marketing specialist who will be in London from April 5 to mid April on business. We are pleased to introduce Mr. Wang You, our import manager of Textiles Department. Mr. Wang is spending three weeks in your city to develop our business with chief manufactures and to make purchases of decorative fabrics for the coming season.We shall be most grateful if you will introduce him to reliable manufacturers and give him any help or advice he may need.", "Track progress", "Finishes\ninvestigation\nFinishes\ninvestigation\nFinishes\ninvestigation\nFinishes\ninvestigation"][index]
            return ["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation","Finishes\ninvestigation"][index]
        }
    
    var stepper: UIStepper?
    var indicator: EasyStepIndicator?
    var currentStep: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.indicator = EasyStepIndicator.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 200), size: CGSize.init(width: self.view.bounds.width, height: self.view.bounds.width)))
        indicator?.delegate = self
        indicator?.dataSource = self
        self.view.addSubview(indicator!)
        indicator?.numberOfSteps = 4//如果需要调整步骤
        indicator?.currentStep = 0 //如果需要调整目前进度
        
        self.stepper = UIStepper.init(frame: CGRect.init(origin: CGPoint.init(x: self.view.bounds.midX - 15, y: 500), size: CGSize.init(width: 30, height: 20)))
        self.view.addSubview((stepper!))
        stepper?.maximumValue = 4
        stepper?.minimumValue = 0
        stepper?.stepValue = 1
        stepper?.value = 0
        stepper?.addTarget(self, action: #selector(valueChange), for: .valueChanged)
    }

    @objc func valueChange() {
        indicator?.currentStep = Int(self.stepper?.value ?? 0)
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
