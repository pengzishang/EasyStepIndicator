//
//  Config.swift
//  EasyStepIndicator
//
//  Created by pengzishang on 2019/10/30.
//  Copyright © 2019 pengzishang. All rights reserved.
//

import Foundation
import UIKit

protocol EasyStepIndicatorDataSource : class {
    func stepConfigForStep(indicator:EasyStepIndicator,index:Int) -> StepConfig
    func lineConfigForProcess(indicator:EasyStepIndicator,index:Int) -> LineConfig
    
    func viewForProcess(indicator:EasyStepIndicator, index:Int) -> UIView
    func characterForStep(indicator:EasyStepIndicator, index:Int) -> String
    func titleForStep(indicator:EasyStepIndicator,index:Int)-> String
}

protocol EasyStepIndicatorDelegate : class {
    func didChangeStep(indicator:EasyStepIndicator, index:Int)
}

let defaultIncompleteColor = UIColor.red
let defaultCompleteColor = UIColor.green

struct StatusColorPattern {
    var complete:UIColor? = defaultCompleteColor
    var incomplete:UIColor? =  defaultIncompleteColor
}

struct LineDashPattern {
    //单个虚线长度
    public var width: Float? = 3
    //虚线间隔
    public var margin: Float? = 2
}

struct StepConfig {
    public var stepText = Text()
    public var title = Text()
    public var annular = Annular()
    public var tint = Tint()
    
    public var radius: CGFloat
    public let stepIndex: Int
    public var titleMargin: CGFloat = 3
    
    struct Text {
        public var fontSize : CGFloat = 18
        public var colors = StatusColorPattern()
        public var content : String?
    }
    struct Annular {
        public var colors = StatusColorPattern()
        public var dashPattern = LineDashPattern()
        //指示圆框线条的宽度
        public var strokeWidth: CGFloat? = 1.0
    }
    struct Tint {
        public var colors = StatusColorPattern()
    }
    
//    init(radius:CGFloat , stepIndex:Int) {
//        self.radius = radius
//        self.stepIndex = stepIndex
//    }
}


struct LineConfig {
    public var colors = StatusColorPattern()
    public var dashPattern  = LineDashPattern()
    //线条宽度
    public var strokeWidth: CGFloat? = 4.0
    //指向线条离圆形的初始距离
    public var marginBetweenCircle : CGFloat? = 2.0
    public var processIndex : Int = 0
    public var isHorizontal: Bool = true
}
