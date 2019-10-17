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
    var tintColor: UIColor?
    
    var defaultColor: UIColor?
    
    var currentStepAsIncomplete = false
    
    var isFinished: Bool = false
    
    var isCurrent: Bool = false
    
    var isHorizontal: Bool = true 
    
    var showAnimating = true

    // MARK: - Initialization
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    // MARK: - Functions
    func updateStatus() {
        tintLineLayer.removeFromSuperlayer()
        self.drawLinePath()
        if isFinished {
            self.drawTintLineAnimated(didFinished: true)
        } else if isCurrent {
            self.drawTintLineAnimated(didFinished: !currentStepAsIncomplete)
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

    private func drawTintLineAnimated(didFinished:Bool) {
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
        self.tintLineLayer.strokeColor = didFinished ? self.tintColor?.cgColor : self.defaultColor?.cgColor
        self.tintLineLayer.lineWidth = self.lineWidth
        self.tintLineLayer.backgroundColor = UIColor.clear.cgColor
        self.tintLineLayer.lineDashPattern = didFinished ? nil : self.lineDashPattern
        self.addSublayer(self.tintLineLayer)

    }
    
    private func animateLine() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        self.tintLineLayer.add(animation, forKey: "animationDrawLine")
    }
}
