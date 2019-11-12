//
//  DescriptionTextLayer.swift
//  homesecurity
//
//  Created by pengzishang on 2019/9/29.
//  Copyright © 2019 Hub 6 Inc. All rights reserved.
//

import UIKit

class DescriptionTextLayer: CAShapeLayer {
	
	private let tintTextLayer = CATextLayer()
	
    public var config: TitleConfig = TitleConfig.init(stepIndex: 0)
	
	public var indicator: EasyStepIndicator = EasyStepIndicator()
	
	public var isHorizontal: Bool = true
	
	public var titleSize: CGSize?
	
	init(titleConfig: TitleConfig, target: EasyStepIndicator) {
		super.init()
		self.config = titleConfig
		self.fillColor = UIColor.clear.cgColor
		self.indicator = target
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(layer: Any) {
		super.init(layer: layer)
	}
	
	fileprivate func drawText() {
		self.tintTextLayer.removeFromSuperlayer()
		self.tintTextLayer.string = config.title.content
		self.tintTextLayer.alignmentMode = .center
		self.tintTextLayer.font = UIFont.systemFont(ofSize: config.title.fontSize)
		self.tintTextLayer.fontSize = config.title.fontSize
		self.tintTextLayer.contentsScale = UIScreen.main.scale
		self.tintTextLayer.frame = self.bounds.integral
		self.tintTextLayer.isWrapped = true
        self.tintTextLayer.truncationMode = .end
//        self.tintTextLayer.backgroundColor = UIColor.gray.cgColor
	}
	
	func updateStatus() {
		
		guard let _ = config.title.content else {
			return
		}
		
		self.isHorizontal = indicator.direction == .leftToRight || indicator.direction == .rightToLeft
		
		self.drawText()
		if indicator.currentStep > config.stepIndex {
			self.tintTextLayer.foregroundColor = config.colors.complete?.cgColor
		} else if indicator.currentStep == config.stepIndex {
			self.tintTextLayer.foregroundColor = indicator.currentStepAsIncomplete ?
				config.colors.incomplete?.cgColor : config.colors.complete?.cgColor
		} else {
			self.tintTextLayer.foregroundColor = config.colors.incomplete?.cgColor
		}
		self.addSublayer(self.tintTextLayer)
	}
}
