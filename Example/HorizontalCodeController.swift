//
//  HorizontalCodeController.swift
//  EasyStepIndicator
//
//  Created by pengzishang on 2019/10/17.
//  Copyright © 2019 pengzishang. All rights reserved.
//

import UIKit

class HorizontalCodeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicator = EasyStepIndicator.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width:300, height: 300)))
        self.view.addSubview(indicator)
        indicator.numberOfSteps = 4//如果需要调整步骤
        indicator.currentStep = 2 //如果需要调整目前进度
        indicator.circleRadius = 15 //圆圈大小
        indicator.showCircleText = true
        indicator.stepCircleTexts = ["A","B","C","D"]//框内的文字
        indicator.showStepDescriptionTexts = true
        indicator.stepDescriptionTexts = ["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation"]//圆下的描述文字
        indicator.direction = .leftToRight //方向
        //如果你使用纵向模式
        indicator.stepLineFitDescriptionText = true //连接线条长度适应文本
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
