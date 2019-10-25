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
    //步骤描述文字
    public var stepDescriptionText : String = ""
    
    //步骤描述文字未完成时候颜色
    public var stepDescriptionTextIncompleteColor: UIColor = UIColor.red
    
    //步骤描述文字完成时候颜色
    public var stepDescriptionTextCompleteColor: UIColor = UIColor.green
    
    //步骤描述文字的大小
    public var stepDescriptionTextFontSize : CGFloat = 18
    
    var currentStepAsIncomplete = false
    
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
        self.tintTextLayer.string = stepDescriptionText
//        self.tintTextLayer.
        self.tintTextLayer.alignmentMode = .center
        self.tintTextLayer.font = UIFont.systemFont(ofSize: self.stepDescriptionTextFontSize)
        self.tintTextLayer.fontSize = self.stepDescriptionTextFontSize
        self.tintTextLayer.contentsScale = UIScreen.main.nativeScale
        self.tintTextLayer.backgroundColor = UIColor.clear.cgColor
        self.tintTextLayer.frame = self.bounds.integral
        self.tintTextLayer.zPosition = 1000
        self.tintTextLayer.isWrapped = true
    }
    
    func updateStatus() {
        guard stepDescriptionText.count > 0 else{
            return
        }
        self.drawText()
        if isFinished {
            self.tintTextLayer.foregroundColor = stepDescriptionTextCompleteColor.cgColor
        } else if isCurrent{
            self.tintTextLayer.foregroundColor = currentStepAsIncomplete ?
                stepDescriptionTextIncompleteColor.cgColor: stepDescriptionTextCompleteColor.cgColor
        } else {
            self.tintTextLayer.foregroundColor = stepDescriptionTextIncompleteColor.cgColor
        }
        self.addSublayer(self.tintTextLayer)
    }
    
    override init() {
        super.init()
        self.fillColor = UIColor.clear.cgColor
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
