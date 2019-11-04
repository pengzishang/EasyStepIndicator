//
//  LineLayer.swift
//  homesecurity
//
//  Created by DeshPeng on 2018/12/5.
//  Copyright © 2018年 Hub 6 Inc. All rights reserved.
//

import UIKit

class LineLayer: CAShapeLayer {

    private let tintLineLayer = CAShapeLayer()

    // MARK: - Properties

    var showAnimating = true
    
    public var indicator:EasyStepIndicator?
    
    public var config : LineConfig?

    public var isHorizontal: Bool = true
    // MARK: - Initialization
    
    required init(config:LineConfig) {
        super.init()
        self.config = config
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Functions
    func updateStatus() {
        tintLineLayer.removeFromSuperlayer()
        
        guard let indicator = indicator else {
            assertionFailure("没有指定EasyStepIndicator")
            return
        }
        
        self.isHorizontal = indicator.direction == .leftToRight || indicator.direction == .rightToLeft
        
        self.drawLinePath()
        if config?.processIndex ?? 0 < indicator.currentStep - 1 {
            self.drawTintLineAnimated(didFinished: true)
        } else if config?.processIndex == indicator.currentStep - 1 {
            self.drawTintLineAnimated(didFinished: !indicator.currentStepAsIncomplete)
            if showAnimating {
                self.animateLine()
            }
        } else {
            self.drawTintLineAnimated(didFinished: false)
        }
    }

    private func drawLinePath() {
        let linePath = UIBezierPath()

        if self.isHorizontal {
            let centerY = self.frame.height / 2.0
            linePath.move(to: CGPoint(x: 0, y: centerY))
            linePath.addLine(to: CGPoint(x: self.frame.width, y: centerY))
        } else {
            let centerX = self.frame.width / 2.0
            linePath.move(to: CGPoint(x: centerX, y: 0))
            linePath.addLine(to: CGPoint(x: centerX, y: self.frame.height))
        }

        self.path = linePath.cgPath
    }

    private func drawTintLineAnimated(didFinished: Bool) {
        let tintLinePath = UIBezierPath()

        if self.isHorizontal {
            let centerY = self.frame.height / 2.0
            tintLinePath.move(to: CGPoint(x: 0, y: centerY))
            tintLinePath.addLine(to: CGPoint(x: self.frame.width, y: centerY))
        } else {
            let centerX = self.frame.width / 2.0
            tintLinePath.move(to: CGPoint(x: centerX, y: 0))
            tintLinePath.addLine(to: CGPoint(x: centerX, y: self.frame.height))
        }

        self.tintLineLayer.path = tintLinePath.cgPath
        self.tintLineLayer.frame = self.bounds
        self.tintLineLayer.strokeColor = didFinished ? config?.colors.complete?.cgColor : config?.colors.incomplete?.cgColor
        self.tintLineLayer.lineWidth = config?.strokeWidth ?? 4
        self.tintLineLayer.backgroundColor = UIColor.clear.cgColor
        var dashPatternComplete : [NSNumber]?
        var dashPatternIncomplete : [NSNumber]?
        
        if config?.dashPatternComplete.width ?? 3 != 0 || config?.dashPatternComplete.margin ?? 2 != 0 {
            dashPatternComplete = [NSNumber.init(value: config?.dashPatternComplete.width ?? 3), NSNumber.init(value: config?.dashPatternComplete.margin ?? 2)]
        }
        
        if config?.dashPatternIncomplete.width ?? 3 != 0 || config?.dashPatternIncomplete.margin ?? 2 != 0 {
            dashPatternIncomplete = [NSNumber.init(value: config?.dashPatternIncomplete.width ?? 3), NSNumber.init(value: config?.dashPatternIncomplete.margin ?? 2)]
        }
        
        self.tintLineLayer.lineDashPattern = didFinished ? dashPatternComplete : dashPatternIncomplete
        self.addSublayer(self.tintLineLayer)
    }

    private func animateLine() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        self.tintLineLayer.add(animation, forKey: "animationDrawLine")
    }
}
