//
//  Config.swift
//  EasyStepIndicator
//
//  Created by pengzishang on 2019/10/30.
//  Copyright © 2019 pengzishang. All rights reserved.
//

import Foundation
import UIKit

let defaultIncompleteColor = UIColor.red
let defaultCompleteColor = UIColor.green

protocol EasyStepIndicatorDataSource: class {
	func characterForStep(indicator: EasyStepIndicator, index: Int) -> String
	func titleForStep(indicator: EasyStepIndicator, index: Int) -> String
}

protocol EasyStepIndicatorDelegate: class {
	func didChangeStep(indicator: EasyStepIndicator, index: Int)
	func stepConfigForStep(indicator: EasyStepIndicator, index: Int, config: inout StepConfig)
	func lineConfigForProcess(indicator: EasyStepIndicator, index: Int, config: inout LineConfig)
	func titleConfigForStep(indicator: EasyStepIndicator, index: Int, config: inout TitleConfig)
	func shouldStepLineFitDescriptionText() -> Bool
}

public enum Direction: UInt {
	case leftToRight = 0, rightToLeft, topToBottom, bottomToTop
}



public enum AlignmentMode: UInt {
	case top = 0, //每个标题和圆圈的起始对齐
		 center, //每个标题和起始和圆圈的中心对齐
		 centerWithAnnularStartAndAnnularEnd //标题和圆圈中心对齐,且强制以第一个圆圈的顶作为layer起始点,可能会超出superview
}

struct StatusColorPattern {
	var complete: UIColor? = defaultCompleteColor
	var incomplete: UIColor? = defaultIncompleteColor
}

struct LineDashPattern {
	//单个虚线长度
	public var width: Float? = 3
	//虚线间隔
	public var margin: Float? = 2
}

struct Text {
	public var fontSize: CGFloat = 18
	public var colors = StatusColorPattern()
	public var content: String?
	public var style: NSMutableParagraphStyle = {
		let style = NSMutableParagraphStyle.init()
		style.alignment = .center
		return style
	}()
}

struct StepConfig {
	public var stepText = Text()
	public var annular = Annular()
	public var tint = Tint()
	
	public var radius: CGFloat
	public let stepIndex: Int
	public var titleMargin: CGFloat = 3
	
	struct Annular {
		public var colors = StatusColorPattern()
		public var dashPatternComplete = LineDashPattern()
		public var dashPatternIncomplete = LineDashPattern()
		//指示圆框线条的宽度
		public var strokeWidth: CGFloat = 2.0
	}
	
	struct Tint {
		public var colors = StatusColorPattern()
	}
	
	init(radius: CGFloat, stepIndex: Int) {
		self.radius = radius
		self.stepIndex = stepIndex
	}
}


struct LineConfig {
	public var colors = StatusColorPattern()
	public var dashPatternComplete = LineDashPattern()
	public var dashPatternIncomplete = LineDashPattern()
	//线条宽度
	public var strokeWidth: CGFloat = 4.0
	//指向线条离圆形的初始距离
	public var marginBetweenCircle: CGFloat = 2.0
	public var processIndex: Int
}


struct TitleConfig {
	public var title: Text = Text()
	public var colors = StatusColorPattern()
	public let stepIndex: Int
	
	init(stepIndex: Int) {
		self.stepIndex = stepIndex
	}
}

//TODO:加入完成,当前,未完成三种状态
//TODO:多余字省略
