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
    
    public var config: TitleConfig?
    
    public var indicator :EasyStepIndicator?

    init(titleConfig:TitleConfig,target:EasyStepIndicator) {
        super.init()
        self.config = titleConfig
        self.fillColor = UIColor.clear.cgColor
        self.indicator = target
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func drawText() {
        guard let config = self.config else {
            assertionFailure("没有指定config")
            return
        }
        
        self.tintTextLayer.removeFromSuperlayer()
        self.tintTextLayer.string = config.title.content
        self.tintTextLayer.alignmentMode = .center
        self.tintTextLayer.font = UIFont.systemFont(ofSize: config.title.fontSize )
        self.tintTextLayer.fontSize = config.title.fontSize
        self.tintTextLayer.contentsScale = UIScreen.main.nativeScale
        self.tintTextLayer.backgroundColor = UIColor.clear.cgColor
        self.tintTextLayer.frame = self.bounds.integral
        self.tintTextLayer.zPosition = 1000
        self.tintTextLayer.isWrapped = true
    }

    func updateStatus() {

        guard let indicator = indicator else {
            assertionFailure("没有指定EasyStepIndicator")
            return
        }
        
        guard let config = self.config else {
            assertionFailure("没有指定config")
            return
        }
        
        guard let _ = config.title.content else {
            return
        }
        
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
