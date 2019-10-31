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

    public var indicator:EasyStepIndicator?

    public var config:StepConfig?

    // MARK: - Initialization
    
    required init(config:StepConfig) {
        super.init()
        self.config = config
        self.fillColor = UIColor.clear.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions
    public func updateStatus() {

        self.centerCircleLayer.removeFromSuperlayer()
        guard let indicator = indicator else {
            assertionFailure("没有指定EasyStepIndicator")
            return
        }
        
        if indicator.currentStep > config?.stepIndex ?? 0{//已经完成的步骤
            self.path = nil
            self.drawCenterCircleAnimated(didFinished: true)
                self.drawText(didFinished: true)
        } else {
            self.drawAnnularPath()
            if indicator.currentStep == config?.stepIndex ?? 0 {//当前步骤
                self.drawCenterCircleAnimated(didFinished: indicator.currentStepAsIncomplete)
                self.animateCenter()
                    self.drawText(didFinished: !indicator.currentStepAsIncomplete)
            } else {
                self.drawCenterCircleAnimated(didFinished: false)
                self.drawText(didFinished: false)
            }
        }
    }

    private func drawAnnularPath() {
        let circlesRadius = fmin(self.frame.width, self.frame.height) / 2.0 - self.lineWidth / 2.0
        self.annularPath.removeAllPoints()
        self.annularPath.addArc(withCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: circlesRadius, startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)

        self.path = self.annularPath.cgPath
    }

    private func drawText(didFinished: Bool) {
        guard let stepCircleText = config?.stepText.content else {
            return
        }
        let sideLength = fmin(self.frame.width, self.frame.height)
        self.centerTextLayer.string = stepCircleText
        self.centerTextLayer.frame = self.bounds
        self.centerTextLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY * 1.2)
        self.centerTextLayer.contentsScale = UIScreen.main.scale
        self.centerTextLayer.alignmentMode = CATextLayerAlignmentMode.center
        let fontSize = sideLength * 0.65
        self.centerTextLayer.font = UIFont.boldSystemFont(ofSize: fontSize) as CFTypeRef
        self.centerTextLayer.fontSize = fontSize
        self.centerTextLayer.foregroundColor = didFinished ? config?.stepText.colors.complete?.cgColor : config?.stepText.colors.incomplete?.cgColor
        self.addSublayer(self.centerTextLayer)
    }

    private func drawCenterCircleAnimated(didFinished: Bool) {
        let centerPath = UIBezierPath()
        let circlesRadius = min(self.frame.width, self.frame.height) / 2.0 - 1
        centerPath.addArc(withCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: circlesRadius, startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)

        self.centerCircleLayer.path = centerPath.cgPath
        self.centerCircleLayer.transform = AnnularLayer.originalScale
        self.centerCircleLayer.frame = self.bounds
        self.centerCircleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.centerCircleLayer.fillColor = didFinished ?
            config?.tint.colors.complete?.cgColor : config?.tint.colors.incomplete?.cgColor
        self.centerCircleLayer.lineWidth = self.lineWidth
        self.centerCircleLayer.strokeColor = didFinished ?
            config?.annular.colors.complete?.cgColor : config?.annular.colors.incomplete?.cgColor
        self.centerCircleLayer.lineDashPattern = didFinished ? nil : self.lineDashPattern
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
