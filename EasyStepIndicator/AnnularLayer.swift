//
//  AnnularLayer.swift
//  homesecurity
//
//  Created by DeshPeng on 2018/12/5.
//  Copyright © 2018年 Hub 6 Inc. All rights reserved.
//

import UIKit

class AnnularLayer: CAShapeLayer {
	
	private let centerTextLayer = CATextLayer()
	private let centerCircleLayer = CAShapeLayer()
	private let annularPath = UIBezierPath()
	static let originalScale = CATransform3DMakeScale(1.0, 1.0, 1.0)
	
	// MARK: - Properties
	
	public var indicator: EasyStepIndicator = EasyStepIndicator()
    public var config: StepConfig = StepConfig.init(radius: 20, stepIndex: 0)
	
	// MARK: - Initialization
	
	required init(config: StepConfig) {
		super.init()
		self.config = config
		self.fillColor = UIColor.clear.cgColor
	}
	
	override init(layer: Any) {
		super.init(layer: layer)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Functions
	public func updateStatus() {
		self.centerTextLayer.removeFromSuperlayer()
		self.centerCircleLayer.removeFromSuperlayer()
		
        if indicator.currentStep > config.stepIndex {//已经完成的步骤
			self.path = nil
			self.drawCenterCircle(didFinished: true)
			self.drawText(didFinished: true)
		} else {
			self.drawAnnularPath()
            if indicator.currentStep == config.stepIndex {//当前步骤
				self.drawCenterCircle(didFinished: !indicator.currentStepAsIncomplete)
				self.animateCenter()
				self.drawText(didFinished: !indicator.currentStepAsIncomplete)
			} else {
				self.drawCenterCircle(didFinished: false)
				self.drawText(didFinished: false)
			}
		}
	}
	
	private func drawAnnularPath() {
        let circlesRadius = (self.config.radius )
		self.annularPath.removeAllPoints()
		self.annularPath.addArc(withCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: circlesRadius, startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)
		self.path = self.annularPath.cgPath
	}
	
	private func drawText(didFinished: Bool) {
		
		guard let stepCircleText = config.stepText.content else {
			return
		}

        let fontSize = self.config.stepText.fontSize 
		let font = UIFont.boldSystemFont(ofSize: fontSize)
		let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: config.stepText.style]
		let attributesText = NSAttributedString(string: stepCircleText, attributes: attributes as [NSAttributedString.Key: Any])
		let textSize = attributesText.boundingRect(with: CGSize.init(width: self.frame.width, height: self.frame.height), options: .usesLineFragmentOrigin, context: nil).size
		
		self.centerTextLayer.string = stepCircleText
		self.centerTextLayer.frame = CGRect.init(origin: CGPoint.init(x: self.bounds.midX - textSize.width / 2, y: self.bounds.midY - textSize.height / 2), size: textSize)
		self.centerTextLayer.contentsScale = UIScreen.main.scale
		self.centerTextLayer.alignmentMode = CATextLayerAlignmentMode.center
		self.centerTextLayer.font = font
		self.centerTextLayer.fontSize = fontSize
		//TODO
		self.centerTextLayer.foregroundColor = didFinished ? config.stepText.colors.complete?.cgColor : config.stepText.colors.incomplete?.cgColor
		self.addSublayer(self.centerTextLayer)
	}
	
	private func drawCenterCircle(didFinished: Bool) {
		
		let centerPath = UIBezierPath()
        let circlesRadius = min(self.frame.width, self.frame.height) / 2.0 - (self.config.annular.strokeWidth )/2
		centerPath.addArc(withCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: circlesRadius, startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)
		
		self.centerCircleLayer.path = centerPath.cgPath
		self.centerCircleLayer.transform = AnnularLayer.originalScale
		self.centerCircleLayer.frame = self.bounds
		self.centerCircleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		self.centerCircleLayer.fillColor = didFinished ?
			config.tint.colors.complete?.cgColor : config.tint.colors.incomplete?.cgColor
        self.centerCircleLayer.lineWidth = config.annular.strokeWidth
		self.centerCircleLayer.strokeColor = didFinished ?
			config.annular.colors.complete?.cgColor : config.annular.colors.incomplete?.cgColor
		
		var dashPatternComplete: [NSNumber]?
		var dashPatternIncomplete: [NSNumber]?
		
		if config.annular.dashPatternComplete.width ?? 3 != 0 || config.annular.dashPatternComplete.margin ?? 2 != 0 {
			dashPatternComplete = [NSNumber.init(value: config.annular.dashPatternComplete.width ?? 3), NSNumber.init(value: config.annular.dashPatternComplete.margin ?? 2)]
		}
		
		if config.annular.dashPatternIncomplete.width ?? 3 != 0 || config.annular.dashPatternIncomplete.margin ?? 2 != 0 {
			dashPatternIncomplete = [NSNumber.init(value: config.annular.dashPatternIncomplete.width ?? 3), NSNumber.init(value: config.annular.dashPatternIncomplete.margin ?? 2)]
		}
		
		self.centerCircleLayer.lineDashPattern = didFinished ? dashPatternComplete : dashPatternIncomplete
		self.addSublayer(self.centerCircleLayer)
	}
	
	private func animateCenter() {
		self.centerCircleLayer.transform = CATransform3DMakeScale(0.8, 0.8, 1.0)
		CATransaction.begin()
		CATransaction.setCompletionBlock {
			CATransaction.setCompletionBlock {
				self.centerCircleLayer.transform = AnnularLayer.originalScale
				self.centerCircleLayer.removeAllAnimations()
			}
			self.centerCircleLayer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0)
			self.centerCircleLayer.removeAllAnimations()
			self.centerCircleLayer.add(self.createTransformAnimationWithScale(x: 1.0, y: 1.0), forKey: "CenterLayerAnimationScale1.0")
		}
		self.centerCircleLayer.add(self.createTransformAnimationWithScale(x: 1.1, y: 1.1), forKey: "CenterLayerAnimationScale1.1")
		CATransaction.commit()
	}
	
	private func createTransformAnimationWithScale(x: CGFloat, y: CGFloat) -> CABasicAnimation {
		let animation = CABasicAnimation()
		animation.keyPath = "transform"
		animation.isRemovedOnCompletion = false
		animation.fillMode = CAMediaTimingFillMode.forwards
		animation.toValue = CATransform3DMakeScale(x, y, 1)
		return animation
	}
}
