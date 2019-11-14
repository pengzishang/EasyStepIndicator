//
//  TitleOppositeLayer.swift
//  EasyStepIndicator
//
//  Created by pengzishang on 2019/11/14.
//  Copyright © 2019 pengzishang. All rights reserved.
//

import UIKit

class TitleOppositeLayer: CALayer {
    
    private let oppositeLayer = CALayer()
    
    public var indicator: EasyStepIndicator = EasyStepIndicator()
    
    public var stepIndex = 0
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(stepIndex:Int) {
        super.init()
        self.stepIndex = stepIndex
    }
    
    func updateStatusWith(layer: CALayer?) {
        guard let layer = layer else {
            return
        }
        oppositeLayer.removeFromSuperlayer()
        layer.frame = self.bounds
        oppositeLayer.addSublayer(layer)
        self.addSublayer(oppositeLayer)
    }
}
