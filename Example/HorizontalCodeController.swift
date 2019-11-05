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
            if index == 2{
                //代码文字没有其效果
                config.radius = 30
                config.stepText.colors.complete = UIColor.white
                config.stepText.colors.incomplete = UIColor.black
            }
            if index == 3 {
                config.titleMargin = 20
                config.stepText.fontSize = 30
            }
            return config
        }
        
        func lineConfigForProcess(indicator: EasyStepIndicator, index: Int, config:inout LineConfig) -> LineConfig {
            return config
        }
        
        func titleConfigForStep(indicator: EasyStepIndicator, index: Int, config:inout TitleConfig) -> TitleConfig {
            config.colors.complete = UIColor.white
            config.colors.incomplete = UIColor.black
            return config
        }
        
        func shouldStepLineFitDescriptionText() -> Bool {
            true
        }
        
        func characterForStep(indicator: EasyStepIndicator, index: Int) -> String {
            return "abc"
        }
        
        func titleForStep(indicator: EasyStepIndicator, index: Int) -> String {
    //        return["Yours faithfully", " This is to introduce Mr. Frank Jones, our new marketing specialist who will be in London from April 5 to mid April on business. We are pleased to introduce Mr. Wang You, our import manager of Textiles Department. Mr. Wang is spending three weeks in your city to develop our business with chief manufactures and to make purchases of decorative fabrics for the coming season.We shall be most grateful if you will introduce him to reliable manufacturers and give him any help or advice he may need.", "Track progress", "Finishes\ninvestigation\nFinishes\ninvestigation\nFinishes\ninvestigation\nFinishes\ninvestigation"][index]
            return ["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation","Finishes\ninvestigation"][index]
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let indicator = EasyStepIndicator.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 300, height: 300)))
        indicator.delegate = self
        indicator.dataSource = self
        self.view.addSubview(indicator)
        indicator.numberOfSteps = 4//如果需要调整步骤
        indicator.currentStep = 2 //如果需要调整目前进度
//        indicator.circleRadius = 15 //圆圈大小
//        indicator.showCircleText = true
//        indicator.stepCircleTexts = ["A", "B", "C", "D"]//框内的文字
//        indicator.showStepDescriptionTexts = true
//        indicator.stepDescriptionTexts = ["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation"]//圆下的描述文字
//        indicator.direction = .leftToRight //方向
//        //如果你使用纵向模式
//        indicator.stepLineFitDescriptionText = true //连接线条长度适应文本
        // Do any additional setup after loading the view.
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
