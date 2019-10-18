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
    
    let centerCircleLayer = CAShapeLayer()
    let annularPath = UIBezierPath()

    static let originalScale = CATransform3DMakeScale(1.0, 1.0, 1.0)

    // MARK: - Properties
    
    var incompleteTintColor: UIColor?
    var completeTintColor: UIColor?
    
    var step: Int = 0
    
    //外框未完成时候的颜色
    var circleBorderIncompleteColor: UIColor = UIColor.red
    //外框完成时候的颜色
    var circleBorderCompleteColor: UIColor = UIColor.green
    //里面文字在未完成的时候的颜色
    var circleTextIncompleteColor: UIColor = UIColor.green
    //里面文字在完成的时候的颜色
    var circleTextCompleteColor: UIColor = UIColor.red
    
    var currentStepAsIncomplete = false
    
    var showCircleText: Bool = false
    
    var stepCircleText : String?
    
    var isCurrent: Bool = false

    var isFinished: Bool = false

    // MARK: - Initialization
    required override init() {
        super.init()
        self.fillColor = UIColor.clear.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    // MARK: - Functions
    func updateStatus() {
        self.centerCircleLayer.removeFromSuperlayer()
        if isFinished {//已经完成的步骤
            self.path = nil
            self.drawCenterCircleAnimated(didFinished: true)
            if showCircleText {
                self.drawText(didFinished: true)
            }
        } else {
            self.drawAnnularPath()
            if isCurrent {//当前步骤
                self.drawCenterCircleAnimated(didFinished: !currentStepAsIncomplete)
                self.animateCenter()
                if showCircleText {
                    self.drawText(didFinished: !currentStepAsIncomplete)
                }
            } else {
                self.drawCenterCircleAnimated(didFinished: false)
                if showCircleText {
                    self.drawText(didFinished: false)
                }
            }
        }
    }
    
    func drawAnnularPath() {
        let circlesRadius = fmin(self.frame.width, self.frame.height) / 2.0 - self.lineWidth / 2.0
        self.annularPath.removeAllPoints()
        self.annularPath.addArc(withCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: circlesRadius, startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)

        self.path = self.annularPath.cgPath
    }
    
    func drawText(didFinished:Bool) {
        let sideLength = fmin(self.frame.width, self.frame.height)
        
        self.centerTextLayer.string = stepCircleText ?? "\(self.step)"
        self.centerTextLayer.frame = self.bounds
        self.centerTextLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY * 1.2)
        self.centerTextLayer.contentsScale = UIScreen.main.scale
        self.centerTextLayer.alignmentMode = CATextLayerAlignmentMode.center
        let fontSize = sideLength * 0.65
        self.centerTextLayer.font = UIFont.boldSystemFont(ofSize: fontSize) as CFTypeRef
        self.centerTextLayer.fontSize = fontSize
        self.centerTextLayer.foregroundColor = didFinished ? circleTextCompleteColor.cgColor : circleTextIncompleteColor.cgColor
        self.addSublayer(self.centerTextLayer)
    }

    private func drawCenterCircleAnimated(didFinished:Bool) {
        let centerPath = UIBezierPath()
        let circlesRadius = min(self.frame.width, self.frame.height) / 2.0 - 1
        centerPath.addArc(withCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: circlesRadius, startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)

        self.centerCircleLayer.path = centerPath.cgPath
        self.centerCircleLayer.transform = AnnularLayer.originalScale
        self.centerCircleLayer.frame = self.bounds
        self.centerCircleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.centerCircleLayer.fillColor = didFinished ?
            self.completeTintColor?.cgColor :self.incompleteTintColor?.cgColor
        self.centerCircleLayer.lineWidth = self.lineWidth
        self.centerCircleLayer.strokeColor = didFinished ?
            self.circleBorderCompleteColor.cgColor : self.circleBorderIncompleteColor.cgColor
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
