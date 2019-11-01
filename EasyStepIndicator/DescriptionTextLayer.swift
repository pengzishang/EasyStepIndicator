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
    
    public var titleConfig : TitleConfig?
    
    public var indicator :EasyStepIndicator?

    var isCurrent: Bool = false {
        didSet {
            self.updateStatus()
        }
    }

    var isFinished: Bool = false {
        didSet {
            self.updateStatus()
        }
    }

    fileprivate func drawText() {
        self.tintTextLayer.removeFromSuperlayer()
        self.tintTextLayer.string = titleConfig?.title.content
        self.tintTextLayer.alignmentMode = .center
        self.tintTextLayer.font = UIFont.systemFont(ofSize: titleConfig?.title.fontSize ?? 18)
        self.tintTextLayer.fontSize = titleConfig?.title.fontSize ?? 18
        self.tintTextLayer.contentsScale = UIScreen.main.nativeScale
        self.tintTextLayer.backgroundColor = UIColor.clear.cgColor
        self.tintTextLayer.frame = self.bounds.integral
        self.tintTextLayer.zPosition = 1000
        self.tintTextLayer.isWrapped = true
    }

    func updateStatus() {
        guard titleConfig?.title.content?.count ?? 0 > 0 else {
            return
        }
        self.drawText()
        if isFinished {
            self.tintTextLayer.foregroundColor = titleConfig?.colors.complete?.cgColor
        } else if isCurrent {
            self.tintTextLayer.foregroundColor = indicator?.currentStepAsIncomplete ?? false ?
                titleConfig?.colors.incomplete?.cgColor : titleConfig?.colors.complete?.cgColor
        } else {
            self.tintTextLayer.foregroundColor = titleConfig?.colors.incomplete?.cgColor
        }
        self.addSublayer(self.tintTextLayer)
    }

    required init(titleConfig:TitleConfig) {
        super.init()
        self.titleConfig = titleConfig
        self.fillColor = UIColor.clear.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
