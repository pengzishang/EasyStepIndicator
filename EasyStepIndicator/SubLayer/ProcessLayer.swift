//
//  ProcessLayer.swift
//  EasyStepIndicator
//
//  Created by pengzishang on 2019/11/14.
//  Copyright © 2019 pengzishang. All rights reserved.
//

import UIKit

class ProcessLayer: CALayer {
    private let processLayer = CALayer()
    
    public var indicator: EasyStepIndicator = EasyStepIndicator()
    
    public var processIndex = 0
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(processIndex:Int) {
        super.init()
        self.processIndex = processIndex
    }
    
    func updateStatusWith(layer: CALayer?) {
        guard let layer = layer else {
            return
        }
        processLayer.removeFromSuperlayer()
        layer.frame = self.bounds
        processLayer.addSublayer(layer)
        self.addSublayer(processLayer)
    }
}
