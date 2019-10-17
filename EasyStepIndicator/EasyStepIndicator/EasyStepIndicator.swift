//
//  EasyStepIndicator.swift
//  homesecurity
//
//  Created by DeshPeng on 2018/12/5.
//  Copyright © 2018年 Hub 6 Inc. All rights reserved.
//

import UIKit

public enum EasyStepIndicatorDirection: UInt {
    case leftToRight = 0, rightToLeft, topToBottom, bottomToTop
}

@IBDesignable
public class EasyStepIndicator: UIView {
    
    // Variables
    static let defaultColor = UIColor.red
    static let defaultTintColor = UIColor.green
    private var annularLayers = [AnnularLayer]()
    private var horizontalLineLayers = [LineLayer]()
    private var descriptionTextLayers = [DescriptionTextLayer]()
    private let containerLayer = CALayer()
    
    var annularLayerType : AnnularLayer.Type = AnnularLayer.self
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.setCurrentStep(step: self.currentStep)
        self.updateSubLayers()
    }
    
    // MARK: - Properties
    override public var frame: CGRect {
        didSet {
            self.updateSubLayers()
        }
    }
    //总步骤数量
    @IBInspectable public var numberOfSteps: Int = 5 {
        didSet {
            self.createSteps()
        }
    }
    //当前步骤
    @IBInspectable public var currentStep: Int = -1 {
        didSet {
            if self.annularLayers.count <= 0 {
                return
            }
            self.showLineAnimating = currentStep > oldValue
            self.setCurrentStep(step: self.currentStep)
        }
    }
    //强制当前视为未完成
    @IBInspectable public var currentStepAsIncomplete: Bool = false {
        didSet {
            self.updateSubLayers()
        }
    }
    
    //圆大小
    @IBInspectable public var circleRadius: CGFloat = 10.0 {
        didSet {
            self.updateSubLayers()
        }
    }
    //外框未完成时候的颜色
    @IBInspectable public var circleAnnularIncompleteColor: UIColor = defaultColor {
        didSet {
            self.updateSubLayers()
        }
    }
    //外框完成时候的颜色
    @IBInspectable public var circleAnnularCompleteColor: UIColor = defaultTintColor {
        didSet {
            self.updateSubLayers()
        }
    }
    //外框的宽度
    @IBInspectable public var circleStrokeWidth: CGFloat = 1.0 {
        didSet {
            self.updateSubLayers()
        }
    }
    //指示圆框虚线长度
    @IBInspectable public var circleAnnularLineDashWidth: Float = 3 {
        didSet {
            self.updateSubLayers()
        }
    }
    //指示圆框虚线间隔
    @IBInspectable public var circleAnnularLineDashMargin: Float = 3 {
        didSet {
            self.updateSubLayers()
        }
    }
    //圆内未完成时候的颜色
    @IBInspectable public var circleTintIncompleteColor: UIColor = defaultColor {
        didSet {
            self.updateSubLayers()
        }
    }
    //圆内完成时候的颜色
    @IBInspectable public var circleTintCompleteColor: UIColor = defaultTintColor {
        didSet {
            self.updateSubLayers()
        }
    }
    //指向线条未完成的颜色
    @IBInspectable public var lineIncompleteColor: UIColor = defaultColor {
        didSet {
            self.updateSubLayers()
        }
    }
    //指向线条完成的颜色
    @IBInspectable public var lineCompleteColor: UIColor = defaultTintColor {
        didSet {
            self.updateSubLayers()
        }
    }
    //指向线条离圆形的距离
    @IBInspectable public var lineMargin: CGFloat = 0.0 {
        didSet {
            self.updateSubLayers()
        }
    }
    //指向线条宽度
    @IBInspectable public var lineStrokeWidth: CGFloat = 4.0 {
        didSet {
            self.updateSubLayers()
        }
    }
    
    //指向线条虚线间隔
    @IBInspectable public var lineImaginaryMargin: Float = 1 {
        didSet {
            self.updateSubLayers()
        }
    }
    //指向线条小虚线宽度
    @IBInspectable public var lineImaginaryWidth: Float = 5 {
        didSet {
            self.updateSubLayers()
        }
    }
    
    //增长方向
    public var direction: EasyStepIndicatorDirection = .leftToRight {
        didSet {
            self.updateSubLayers()
        }
    }
    //增长方向RAW
    @IBInspectable var directionRaw: UInt {
        get {
            return self.direction.rawValue
        }
        set {
            let value = newValue > 3 ? 0 : newValue
            self.direction = EasyStepIndicatorDirection(rawValue: value)!
        }
    }
    //是否显示起始圆框
    @IBInspectable public var showInitialStep: Bool = true {
        didSet {
            self.updateSubLayers()
        }
    }

    @IBInspectable public var showCircleText: Bool = false {
        didSet {
            self.updateSubLayers()
        }
    }


    //圆形内描述文字,建议只输入一个数字
    public var stepCircleTexts:[String] = []{
        didSet {
            self.updateSubLayers()
        }
    }
    
    //圆形内描述文字未完成时候颜色
    @IBInspectable public var circleTextIncompleteColor: UIColor = defaultColor {
        didSet {
            self.updateSubLayers()
        }
    }
    
    //圆形内描述文字完成时候颜色
    @IBInspectable public var circleTextCompleteColor: UIColor = defaultColor {
        didSet {
            self.updateSubLayers()
        }
    }
    
    //!!!!!!!!!是否显示步骤描述文字
    @IBInspectable public var showStepDescriptionTexts: Bool = false {
        didSet {
            self.updateSubLayers()
        }
    }
    //步骤描述文字
    public var stepDescriptionTexts:[String] = []{
        didSet {
            self.updateSubLayers()
        }
    }
    
    private var maxFontWidth : CGFloat = UIScreen.main.bounds.width/3
    
    private var maxFontHeight = 0
    
    private var showLineAnimating = true
    
    //步骤描述文字未完成时候颜色
    @IBInspectable public var stepDescriptionTextIncompleteColor: UIColor = UIColor.red {
        didSet {
            self.updateSubLayers()
        }
    }
    
    //步骤描述文字完成时候颜色
    @IBInspectable public var stepDescriptionTextCompleteColor: UIColor = UIColor.green {
        didSet {
            self.updateSubLayers()
        }
    }
    
    //Indicator和Description之间Margin
    @IBInspectable public var stepDescriptionTextMargin : CGFloat = 3 {
        didSet {
            self.updateSubLayers()
        }
    }
    
    //步骤描述文字的大小
    @IBInspectable public var stepDescriptionTextFontSize : CGFloat = 18 {
        didSet {
            self.updateSubLayers()
        }
    }
    
    // MARK: - Functions
    private func createSteps() {
        
        self.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        self.containerLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
        
        self.annularLayers.removeAll()
        self.horizontalLineLayers.removeAll()
        self.descriptionTextLayers.removeAll()
        
        assert(self.numberOfSteps > 0, "步骤数必须大于0")
    
        for i in 0..<self.numberOfSteps {
            
            let annularLayer = AnnularLayer.init()
            self.containerLayer.addSublayer(annularLayer)
            self.annularLayers.append(annularLayer)
            
            if (i < self.numberOfSteps - 1) {
                let lineLayer = LineLayer()
                self.containerLayer.addSublayer(lineLayer)
                self.horizontalLineLayers.append(lineLayer)
            }
            
            let descriptionLayer = DescriptionTextLayer()
            self.containerLayer.addSublayer(descriptionLayer)
            self.descriptionTextLayers.append(descriptionLayer)
        }
        
        self.layer.addSublayer(self.containerLayer)
        
        self.setCurrentStep(step: self.currentStep)
        self.updateSubLayers()
    }
    
    private func updateSubLayers() {
        self.containerLayer.frame = self.layer.bounds
        
        if self.direction == .leftToRight || self.direction == .rightToLeft {
            self.layoutHorizontal()
        } else {
            self.layoutVertical()
        }
        
        self.applyDirection()
    }
    
    private func layoutHorizontal() {
        
        let diameter = self.circleRadius * 2
        let stepWidth = self.numberOfSteps == 1 ?
            0 : (self.containerLayer.frame.width - self.lineMargin * 2 - diameter) / CGFloat(self.numberOfSteps - 1)//每个步骤(一个圈加一整条线的宽度)
        var startY : CGFloat = 0
        var contentHeight : CGFloat = 0
        var size = CGSize.zero
        if showStepDescriptionTexts {//上移
            size = getMaxTextRect().size
            contentHeight = size.height + self.stepDescriptionTextMargin + diameter
            #if DEBUG
            assert(contentHeight < self.containerLayer.frame.height, "文字之间距离过高或者文字过于长,检查stepDescriptionTextMargin和文字长度")
            #else
            contentHeight = min(self.containerLayer.frame.height, contentHeight)
            #endif
            startY = (self.containerLayer.frame.height - contentHeight) / 2 + self.circleRadius
        } else {
            startY = self.containerLayer.frame.height / 2.0
        }
        
        for i in 0 ..< self.annularLayers.count {
            let annularLayer = self.annularLayers[i]
            let x = self.numberOfSteps == 1 ?
                self.containerLayer.frame.width / 2.0 - self.circleRadius : self.lineMargin + CGFloat(i) * stepWidth
            annularLayer.frame = CGRect(x: x, y: startY - self.circleRadius, width: diameter, height: diameter)
            self.applyAnnularStyle(annularLayer: annularLayer, index: i)
            annularLayer.step = i + 1
            annularLayer.updateStatus()

            if (i < self.numberOfSteps - 1) {
                let lineBackgroundHeight: CGFloat = self.lineStrokeWidth
                var y : CGFloat = 0.0
                if showStepDescriptionTexts {//上移
                    y = (self.containerLayer.frame.height - contentHeight) / 2 + self.circleRadius - lineBackgroundHeight / 2.0
                } else {
                    y = self.containerLayer.frame.height / 2.0 - lineBackgroundHeight / 2.0
                }
                let lineLayer = self.horizontalLineLayers[i]
                lineLayer.frame = CGRect(x: CGFloat(i) * stepWidth + diameter + self.lineMargin * 2, y: y, width: stepWidth - diameter - self.lineMargin * 2, height: lineBackgroundHeight)
                self.applyLineStyle(lineLayer: lineLayer)
                lineLayer.updateStatus()
            }
            
            if showStepDescriptionTexts {
                let descriptionStartY = startY + self.circleRadius + self.stepDescriptionTextMargin
                let descriptionStartX = x + self.circleRadius - maxFontWidth/2
                let descriptionLayer = self.descriptionTextLayers[i]
                self.applyDescriptionText(descriptionText: descriptionLayer, index: i)
                descriptionLayer.frame = CGRect.init(x: descriptionStartX, y: descriptionStartY, width: maxFontWidth, height: size.height + 2)//修正两个像素
                descriptionLayer.updateStatus()
            }
            
        }
    }
    //暂时没适配垂直方向的描述文字
    private func layoutVertical() {
        let diameter = self.circleRadius * 2
        let stepHeight = self.numberOfSteps <= 1 ?
            0 : (self.containerLayer.frame.height - self.lineMargin * 2 - diameter) / CGFloat(self.numberOfSteps - 1)
        let startX = self.containerLayer.frame.width / 2.0
        
        for i in 0..<self.annularLayers.count {
            let annularLayer = self.annularLayers[i]
            let y = self.numberOfSteps <= 1 ? self.containerLayer.frame.height / 2.0 - self.circleRadius : self.lineMargin + CGFloat(i) * stepHeight // should add radius?
            annularLayer.frame = CGRect(x: startX - self.circleRadius, y: y, width: diameter, height: diameter)
            self.applyAnnularStyle(annularLayer: annularLayer, index: i)
            annularLayer.step = i + 1
            annularLayer.updateStatus()
            
            if i < self.numberOfSteps - 1 {
                let lineLayer = self.horizontalLineLayers[i]
                let lineBackgroundWidth: CGFloat = self.lineStrokeWidth
                let x = self.containerLayer.frame.width / 2.0 - lineBackgroundWidth / 2.0
                
                lineLayer.frame = CGRect(x: x, y: CGFloat(i) * stepHeight + diameter + self.lineMargin * 2, width: lineBackgroundWidth, height: stepHeight - diameter - self.lineMargin * 2)
                lineLayer.isHorizontal = false
                self.applyLineStyle(lineLayer: lineLayer)
            }
        }
    }
    
    func getMaxTextRect() -> CGRect {
        let text = self.stepDescriptionTexts.reduce(self.stepDescriptionTexts.first ?? "") {return $0.count > $1.count ? $0: $1 }
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let font = UIFont.systemFont(ofSize: stepDescriptionTextFontSize)
        let attributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.paragraphStyle : style]
        let attributesText = NSAttributedString(string: text, attributes: attributes)
        let size = attributesText.boundingRect(with: CGSize.init(width: maxFontWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil)
        return size
    }
    
    private func applyAnnularStyle(annularLayer: AnnularLayer, index: Int) {
        if !showInitialStep && (index == 0) {
            annularLayer.circleBorderIncompleteColor = UIColor.clear
            annularLayer.circleBorderCompleteColor = UIColor.clear
            annularLayer.incompleteTintColor = UIColor.clear
            annularLayer.completeTintColor = UIColor.clear
        } else {
            annularLayer.circleBorderIncompleteColor = self.circleAnnularIncompleteColor
            annularLayer.circleBorderCompleteColor = self.circleAnnularCompleteColor
            annularLayer.incompleteTintColor = self.circleTintIncompleteColor
            annularLayer.completeTintColor = self.circleTintCompleteColor
        }
        
        if showCircleText {
            self.applyStepText(annularLayer: annularLayer, index: index)
        }
        
        annularLayer.lineWidth = self.circleStrokeWidth
        annularLayer.lineDashPattern = [NSNumber.init(value: self.circleAnnularLineDashWidth), NSNumber.init(value: self.circleAnnularLineDashMargin)]
    }
    
    func applyStepText(annularLayer: AnnularLayer, index: Int) {
        annularLayer.showCircleText = true
        annularLayer.circleTextCompleteColor = self.circleTextCompleteColor
        annularLayer.circleTextIncompleteColor = self.circleTextIncompleteColor
        if stepCircleTexts.count > index {
            annularLayer.stepCircleText = stepCircleTexts[index]
        }
    }
    
    func applyDescriptionText(descriptionText: DescriptionTextLayer, index: Int) {
        descriptionText.stepDescriptionTextCompleteColor = self.stepDescriptionTextCompleteColor
        descriptionText.stepDescriptionTextIncompleteColor = self.stepDescriptionTextIncompleteColor
        descriptionText.stepDescriptionTextFontSize = self.stepDescriptionTextFontSize
        if stepDescriptionTexts.count > index {
            descriptionText.stepDescriptionText = stepDescriptionTexts[index]
        }
    }
    
    private func applyLineStyle(lineLayer: LineLayer) {
        lineLayer.defaultColor = self.lineIncompleteColor
        lineLayer.tintColor = self.lineCompleteColor
        lineLayer.lineWidth = self.lineStrokeWidth
        lineLayer.updateStatus()
    }
    
    private func applyDirection() {
        switch self.direction {
        case .rightToLeft:
            let rotation180 = CATransform3DMakeRotation(CGFloat.pi, 0.0, 1.0, 0.0)
            self.containerLayer.transform = rotation180
            for annularLayer in self.annularLayers {
                annularLayer.transform = rotation180
            }
        case .bottomToTop:
            let rotation180 = CATransform3DMakeRotation(CGFloat.pi, 1.0, 0.0, 0.0)
            self.containerLayer.transform = rotation180
            for annularLayer in self.annularLayers {
                annularLayer.transform = rotation180
            }
        default:
            self.containerLayer.transform = CATransform3DIdentity
            for annularLayer in self.annularLayers {
                annularLayer.transform = CATransform3DIdentity
            }
        }
    }
    
    private func setCurrentStep(step: Int) {
        for i in 0 ..< self.numberOfSteps {
            self.setAnnular(isFinished: i < step, isCurrent: i == step, index: i)
            self.setLine(isFinished: self.annularLayers[i].isFinished, isCurrent: self.annularLayers[i].isCurrent, index: i-1)
            self.setDescriptionText(isFinished: self.annularLayers[i].isFinished, isCurrent: self.annularLayers[i].isCurrent, index: i)
        }
    }
    
    private func setAnnular(isFinished: Bool, isCurrent: Bool, index: Int){
        self.annularLayers[index].isCurrent = isCurrent
        self.annularLayers[index].isFinished = isFinished
        self.annularLayers[index].currentStepAsIncomplete = self.currentStepAsIncomplete
        self.annularLayers[index].updateStatus()
    }
    
    private func setLine(isFinished: Bool, isCurrent: Bool, index: Int) {
        if index >= 0 {
            self.horizontalLineLayers[index].showAnimating = self.showLineAnimating
            self.horizontalLineLayers[index].currentStepAsIncomplete = currentStepAsIncomplete
            self.horizontalLineLayers[index].isFinished = isFinished
            self.horizontalLineLayers[index].isCurrent = isCurrent
            self.horizontalLineLayers[index].updateStatus()
            if isFinished {
                self.horizontalLineLayers[index].lineDashPattern = nil
            } else if isCurrent{
                self.horizontalLineLayers[index].lineDashPattern = currentStepAsIncomplete ? [NSNumber.init(value: self.lineImaginaryWidth), NSNumber.init(value: self.lineImaginaryMargin)]: nil
            } else {
                self.horizontalLineLayers[index].lineDashPattern = [NSNumber.init(value: self.lineImaginaryWidth), NSNumber.init(value: self.lineImaginaryMargin)]
            }
            
        }
    }
    
    private func setDescriptionText(isFinished: Bool, isCurrent: Bool, index: Int) {
        if index >= 0 {
            self.descriptionTextLayers[index].currentStepAsIncomplete = currentStepAsIncomplete
            self.descriptionTextLayers[index].isFinished = isFinished
            self.descriptionTextLayers[index].isCurrent = isCurrent
        }
    }
}
