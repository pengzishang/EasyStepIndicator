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

    weak var dataSource : EasyStepIndicatorDataSource? {
        didSet {
            
        }
    }
    weak var delegate : EasyStepIndicatorDelegate? {
        didSet {
            
        }
    }
    // Variables

    private var annularLayers = [AnnularLayer]()
    private var lineLayers = [LineLayer]()
    private var descriptionTextLayers = [DescriptionTextLayer]()
    private let containerLayer = CALayer()

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
    @IBInspectable public var circleRadius: CGFloat = 20.0 {
        didSet {
            self.annularLayers.forEach {$0.config?.radius = circleRadius}
            self.updateSubLayers()
        }
    }
    //指示圆框未完成时候的颜色
    @IBInspectable public var circleAnnularIncompleteColor: UIColor = defaultIncompleteColor {
        didSet {
            self.annularLayers.forEach {$0.config?.annular.colors.incomplete = circleAnnularIncompleteColor}
            self.updateSubLayers()
        }
    }
    //指示圆框完成时候的颜色
    @IBInspectable public var circleAnnularCompleteColor: UIColor = defaultCompleteColor {
        didSet {
            self.annularLayers.forEach {$0.config?.annular.colors.complete = circleAnnularCompleteColor}
            self.updateSubLayers()
        }
    }
    //指示圆框线条的宽度
    @IBInspectable public var circleStrokeWidth: CGFloat = 1.0 {
        didSet {
            self.annularLayers.forEach {$0.config?.annular.strokeWidth = circleStrokeWidth}
            self.updateSubLayers()
        }
    }
    //指示圆框虚线长度
    @IBInspectable public var circleAnnularLineDashWidth: Float = 3 {
        didSet {
            self.annularLayers.forEach {$0.config?.annular.dashPattern.width = circleAnnularLineDashWidth}
            self.updateSubLayers()
        }
    }
    //指示圆框虚线间隔
    @IBInspectable public var circleAnnularLineDashMargin: Float = 3 {
        didSet {
            self.annularLayers.forEach {$0.config?.annular.dashPattern.margin = circleAnnularLineDashMargin}
            self.updateSubLayers()
        }
    }
    //圆内未完成时候的颜色
    @IBInspectable public var circleTintIncompleteColor: UIColor = defaultIncompleteColor {
        didSet {
            self.annularLayers.forEach {$0.config?.tint.colors.incomplete = circleTintIncompleteColor}
            self.updateSubLayers()
        }
    }
    //圆内完成时候的颜色
    @IBInspectable public var circleTintCompleteColor: UIColor = defaultCompleteColor {
        didSet {
            self.annularLayers.forEach {$0.config?.tint.colors.complete = circleTintCompleteColor}
            self.updateSubLayers()
        }
    }
    //指向线条未完成的颜色
    @IBInspectable public var lineIncompleteColor: UIColor = defaultIncompleteColor {
        didSet {
            self.lineLayers.forEach {$0.config?.colors.incomplete = lineIncompleteColor}
            self.updateSubLayers()
        }
    }
    //指向线条完成的颜色
    @IBInspectable public var lineCompleteColor: UIColor = defaultCompleteColor {
        didSet {
            self.lineLayers.forEach {$0.config?.colors.complete = lineCompleteColor}
            self.updateSubLayers()
        }
    }
    //指向线条离圆形的初始距离
    @IBInspectable public var lineMargin: CGFloat = 0.0 {
        didSet {
            self.lineLayers.forEach {$0.config?.marginBetweenCircle = lineMargin}
            self.updateSubLayers()
        }
    }
    //指向线条宽度
    @IBInspectable public var lineStrokeWidth: CGFloat = 4.0 {
        didSet {
            self.lineLayers.forEach {$0.config?.strokeWidth = lineStrokeWidth}
            self.updateSubLayers()
        }
    }

    //指向线条虚线间隔
    @IBInspectable public var lineImaginaryMargin: Float = 1 {
        didSet {
            self.lineLayers.forEach {$0.config?.dashPattern.margin = lineImaginaryMargin}
            self.updateSubLayers()
        }
    }
    //指向线条小虚线宽度
    @IBInspectable public var lineImaginaryWidth: Float = 5 {
        didSet {
            self.lineLayers.forEach {$0.config?.dashPattern.width = lineImaginaryWidth}
            self.updateSubLayers()
        }
    }

    //增长方向
    public var direction: EasyStepIndicatorDirection = .leftToRight {
        didSet {
            self.lineLayers.forEach { $0.config?.isHorizontal = (direction == .leftToRight||direction == .rightToLeft) }
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
//    //是否显示框内文字
//    @IBInspectable public var showCircleText: Bool = false {
//        didSet {
//            self.updateSubLayers()
//        }
//    }
    


    //圆形内描述文字未完成时候颜色
    @IBInspectable public var circleTextIncompleteColor: UIColor = defaultIncompleteColor {
        didSet {
            self.annularLayers.forEach {$0.config?.stepText.colors.incomplete = circleTextIncompleteColor }
            self.updateSubLayers()
        }
    }

    //圆形内描述文字完成时候颜色
    @IBInspectable public var circleTextCompleteColor: UIColor = defaultCompleteColor {
        didSet {
            self.annularLayers.forEach {$0.config?.stepText.colors.complete = circleTextCompleteColor }
            self.updateSubLayers()
        }
    }

//    //是否显示步骤描述文字
//    @IBInspectable public var showStepDescriptionTexts: Bool = false {
//        didSet {
//            self.updateSubLayers()
//        }
//    }

    public var firstHeadingAligmentMode :FirstHeadingAligmentMode = .center
    
    //Line是否适应文字的高度,如果文字过多,建议开启,如果关闭的,Line的高度是与SuperView关联
    public var stepLineFitDescriptionText = false {
        didSet {
            self.updateSubLayers()
        }
    }

    //步骤描述文字未完成时候颜色
    @IBInspectable public var stepDescriptionTextIncompleteColor: UIColor = UIColor.red {
        didSet {
            self.descriptionTextLayers.forEach {$0.titleConfig?.title.colors.incomplete = stepDescriptionTextIncompleteColor }
            self.updateSubLayers()
        }
    }

    //步骤描述文字完成时候颜色
    @IBInspectable public var stepDescriptionTextCompleteColor: UIColor = UIColor.green {
        didSet {
            self.descriptionTextLayers.forEach {$0.titleConfig?.title.colors.complete = stepDescriptionTextCompleteColor }
            self.updateSubLayers()
        }
    }

    //Indicator和Description之间Margin
    @IBInspectable public var stepDescriptionTextMargin: CGFloat = 3 {
        didSet {
            self.annularLayers.forEach {$0.config?.titleMargin = stepDescriptionTextMargin }
            self.updateSubLayers()
        }
    }

    //步骤描述文字的大小
    @IBInspectable public var stepDescriptionTextFontSize: CGFloat = 18 {
        didSet {
            self.descriptionTextLayers.forEach {$0.titleConfig?.title.fontSize = stepDescriptionTextFontSize }
            self.updateSubLayers()
        }
    }

    private var maxFontWidth: CGFloat = UIScreen.main.bounds.width / 3

    private var maxFontHeight = 0

    private var showLineAnimating = true

    private var titleTextSizes: [CGSize] = []
    
    private var titles : [String] = []
    
    private var stepTexts: [String] = []
    
    // MARK: - Init
//    required public override init(frame: CGRect,config: (CircleConfig)->(CircleConfig)) {
//        let c = config(EasyStepIndicator.CircleConfig())
//        super.init(frame: frame)
//    }
    
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    private func createSteps() {

        self.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        self.containerLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })

        self.annularLayers.removeAll()
        self.lineLayers.removeAll()
        self.descriptionTextLayers.removeAll()

        assert(self.numberOfSteps > 0, "步骤数必须大于0")

        for index in 0..<self.numberOfSteps {
            var stepConfig = StepConfig.init(radius: self.circleRadius, stepIndex: index, text: nil)
            if let _dataSource = self.dataSource {
                stepConfig = _dataSource.stepConfigForStep(indicator: self, index: index)
            }
            
            let annularLayer = AnnularLayer.init(config: stepConfig)
            annularLayer.indicator = self
            self.containerLayer.addSublayer(annularLayer)
            self.annularLayers.append(annularLayer)

            if (index < self.numberOfSteps - 1) {
                var lineConfig = LineConfig.init(processIndex: index)
                if let _dataSource = self.dataSource {
                    lineConfig = _dataSource.lineConfigForProcess(indicator: self, index: index)
                }
                let lineLayer = LineLayer.init(config: lineConfig)
                lineLayer.indicator = self
                self.containerLayer.addSublayer(lineLayer)
                self.lineLayers.append(lineLayer)
            }
            
            var titleConfig = TitleConfig.init(stepIndex: index, title: nil)
            if let _dataSource = self.dataSource {
                let title = _dataSource.titleForStep(indicator: self, index: index)
                titleConfig = TitleConfig.init(stepIndex: index, title: title)
            }
            let descriptionLayer = DescriptionTextLayer.init(titleConfig: titleConfig)
            descriptionLayer.indicator = self
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
        maxFontWidth = UIScreen.main.bounds.width / 3
        
        var maxContentHeight: CGFloat = 0
        
        if let _dataSource = self.dataSource {
            let oldTitles = titles
            titles.removeAll()
            for index in 0..<self.numberOfSteps {
                
                let title = _dataSource.titleForStep(indicator: self, index: index)
                titles.append(title ?? "")
            }
            if oldTitles != titles {
                titleTextSizes.removeAll()
                for index in 0..<self.numberOfSteps {
                    let size = self.getTextRect(withIndex: index, maxWidth: CGFloat.greatestFiniteMagnitude).size
                    let stepConfig = _dataSource.stepConfigForStep(indicator: self, index: index)
                    let fontMargin = stepConfig.titleMargin
                    maxContentHeight = max(size.height + fontMargin ,maxContentHeight)
                    titleTextSizes.append(size)
                }
            }
        }
        
        let startY = (self.containerLayer.frame.height - maxContentHeight) / 2  - self.circleRadius //整个图形的起始Y
        
        var processLengths : [CGFloat] = {
            guard self.numberOfSteps > 1 else{
                return Array.init(repeating: 0, count: self.numberOfSteps - 1)
            }
            var processLength : CGFloat = 0
            if let _dataSource = self.dataSource {
                var totalLengthWithoutLine : CGFloat = 0
                for index in 0..<self.numberOfSteps {
                    let stepConfig = _dataSource.stepConfigForStep(indicator: self, index: index)
                    totalLengthWithoutLine += stepConfig.radius * 2
                    if index < self.numberOfSteps - 1 {
                        let lineConfig = _dataSource.lineConfigForProcess(indicator: self, index: index)
                        totalLengthWithoutLine +=  (lineConfig.marginBetweenCircle ?? 0) * 2
                    }
                }
                switch self.firstHeadingAligmentMode {
                case .top:
                    let lastStepConfig = _dataSource.stepConfigForStep(indicator: self, index: self.numberOfSteps - 1)
                    if self.titleTextSizes.last?.width ?? 0 > 2 * lastStepConfig.radius  {
                        totalLengthWithoutLine += (self.titleTextSizes.last?.width ?? 0) - 2 * lastStepConfig.radius
                    }
                case .center:
                    let firstStepConfig = _dataSource.stepConfigForStep(indicator: self, index: 0)
                    let lastStepConfig = _dataSource.stepConfigForStep(indicator: self, index: self.numberOfSteps - 1)
                    if self.titleTextSizes.first?.width ?? 0 > 2 * firstStepConfig.radius  {
                        totalLengthWithoutLine += (self.titleTextSizes.first?.width ?? 0)/2 - firstStepConfig.radius
                    }
                    if self.titleTextSizes.last?.width ?? 0 > 2 * lastStepConfig.radius  {
                        totalLengthWithoutLine += (self.titleTextSizes.last?.width ?? 0)/2 - lastStepConfig.radius
                    }
                case .centerWithAnnularTopStart:
                    break
                }
                processLength = (self.containerLayer.frame.width - totalLengthWithoutLine) / CGFloat(self.numberOfSteps - 1)
            } else {//Storyboard
                processLength = (self.containerLayer.frame.width - self.lineMargin * 2 - 2 * self.circleRadius) / CGFloat(self.numberOfSteps - 1)//每个步骤(一个圈加一整条线的宽度)
            }
            return Array.init(repeating: processLength, count: self.numberOfSteps - 1)
        }()
        
        for index in 0..<self.numberOfSteps {
            if self.numberOfSteps >= 1 {
                if var _lineConfig = self.dataSource?.lineConfigForProcess(indicator: self, index: index) {
                    _lineConfig.processLength = processLengths[index]
                }
            }
        }
        
        func layoutHorizontalAnnularLayers() {
            for _index in 0..<self.annularLayers.count {
                let annularLayer = self.annularLayers[_index]
                let startX : CGFloat = {
                    if let _dataSource = self.dataSource {
                        let firstStepConfig = _dataSource.stepConfigForStep(indicator: self, index: 0)
                        var currentLength : CGFloat = 0
                        
                        switch self.firstHeadingAligmentMode  {
                        case .top:
                            if _index == 0 { return 0 }
                        case .center:
                            if _index == 0 {
                                if firstStepConfig.radius * 2 < self.titleTextSizes.first?.width ?? 0 {
                                    return (self.titleTextSizes.first?.width ?? 0)/2 - firstStepConfig.radius
                                }
                                return 0
                            }
                        case .centerWithAnnularTopStart:
                            if _index == 0 { return 0 }
                        }
                        
                        for __index in 0..<_index {
                            currentLength += _dataSource.stepConfigForStep(indicator: self, index: __index).radius
                            currentLength += _dataSource.lineConfigForProcess(indicator: self, index: __index).marginBetweenCircle ?? 0
                            currentLength += _dataSource.lineConfigForProcess(indicator: self, index: __index).processLength ?? 0
                        }
                        
//                        totalLengthWithoutLine
                        
                        
                    } else {
                        guard self.numberOfSteps > 1 else {
                            return self.containerLayer.frame.width / 2.0 - self.circleRadius
                        }
                        if _index == 0 {
                            return 0
                        } else {
                            let x = (self.lineMargin * 2 + self.circleRadius * 2 + processLengths[_index - 1]) * CGFloat(_index - 1) //每个步骤长度都是一样的
                            return x
                        }
                    }
                }()
                

                
                
                annularLayer.frame = CGRect(x: x, y: startY - self.circleRadius, width: diameter, height: diameter)
                
            }
        }
        
        func layoutHorizontalLineLayer() {
            
        }
        
        func layoutHorizontalTitleLayer() {
            
        }
        
//
//        if showStepDescriptionTexts {//上移
//            if self.stepDescriptionTexts.count == 0 {
//                return
//            }
//            #if DEBUG
//            assert(self.stepDescriptionTexts.count == self.numberOfSteps, "文字数组个数与步骤数不符合")
//            #else
//            if self.stepDescriptionTexts.count > self.numberOfSteps {
//                self.stepDescriptionTexts = Array(self.stepDescriptionTexts.prefix(upTo: self.numberOfSteps))
//            } else if self.stepDescriptionTexts.count < self.numberOfSteps {
//                self.stepDescriptionTexts.append(contentsOf: Array.init(repeating: "", count: self.numberOfSteps - self.stepDescriptionTexts.count))
//            }
//            #endif
//
//            size = getHorizontalMaxTextRect().size
//            maxContentHeight = size.height + self.stepDescriptionTextMargin + diameter
//            #if DEBUG
//            assert(maxContentHeight < self.containerLayer.frame.height, "文字之间距离过高或者文字过于长,检查stepDescriptionTextMargin和文字长度")
//            #else
//            contentHeight = min(self.containerLayer.frame.height, contentHeight)
//            #endif
//            startY = (self.containerLayer.frame.height - maxContentHeight) / 2 + max self.circleRadius
//        } else {
//            startY = self.containerLayer.frame.height / 2.0
//        }
//
//        for i in 0..<self.annularLayers.count {
//            let annularLayer = self.annularLayers[i]
//            let x = self.numberOfSteps <= 1 ?
//                self.containerLayer.frame.width / 2.0 - self.circleRadius : self.lineMargin + CGFloat(i) * stepWidth
//            annularLayer.frame = CGRect(x: x, y: startY - self.circleRadius, width: diameter, height: diameter)
//            self.applyAnnularStyle(annularLayer: annularLayer, index: i)
//            annularLayer.step = i + 1
//            annularLayer.updateStatus()
//
//            if (i < self.numberOfSteps - 1) {
//                let lineBackgroundHeight: CGFloat = self.lineStrokeWidth
//                var y: CGFloat = 0.0
//                if showStepDescriptionTexts {//上移
//                    y = (self.containerLayer.frame.height - maxContentHeight) / 2 + self.circleRadius - lineBackgroundHeight / 2.0
//                } else {
//                    y = self.containerLayer.frame.height / 2.0 - lineBackgroundHeight / 2.0
//                }
//                let lineLayer = self.lineLayers[i]
//                lineLayer.frame = CGRect(x: CGFloat(i) * stepWidth + diameter + self.lineMargin * 2, y: y, width: stepWidth - diameter - self.lineMargin * 2, height: lineBackgroundHeight)
//                self.applyLineStyle(lineLayer: lineLayer)
//                lineLayer.updateStatus()
//            }
//
//            if showStepDescriptionTexts {
//                let descriptionStartY = startY + self.circleRadius + self.stepDescriptionTextMargin
//                let descriptionStartX = x + self.circleRadius - maxFontWidth / 2
//                let descriptionLayer = self.descriptionTextLayers[i]
//                self.applyDescriptionText(descriptionText: descriptionLayer, index: i)
//                descriptionLayer.frame = CGRect.init(x: descriptionStartX, y: descriptionStartY, width: maxFontWidth, height: size.height + 2)//修正两个像素
//                descriptionLayer.updateStatus()
//            }
//
//        }
    }

    private func layoutVertical() {
        let diameter = self.circleRadius * 2
        var stepHeights: [CGFloat] = []
        let verticalFontMargin: CGFloat = 10

        if showStepDescriptionTexts {
            if self.stepDescriptionTexts.count == 0 {
                return
            }
            #if DEBUG
            assert(self.stepDescriptionTexts.count == self.numberOfSteps, "文字数组个数与步骤数不符合")
            #else
            if self.stepDescriptionTexts.count > self.numberOfSteps {
                self.stepDescriptionTexts = Array(self.stepDescriptionTexts.prefix(upTo: self.numberOfSteps))
            } else if self.stepDescriptionTexts.count < self.numberOfSteps {
                self.stepDescriptionTexts.append(contentsOf: Array.init(repeating: "", count: self.numberOfSteps - self.stepDescriptionTexts.count))
            }
            #endif
            maxFontWidth = self.containerLayer.frame.width - stepDescriptionTextMargin - diameter
            textSizes = self.stepDescriptionTexts.compactMap { (target) -> CGRect in
                let style = NSMutableParagraphStyle()
                style.alignment = NSTextAlignment.center
                return self.getTextRect(style, target)
            }

            if stepLineFitDescriptionText {//每个步骤的高度不一样
                var textHeights = titleTextSizes.map {
                    $0.height
                }
                while textHeights.count >= 2 {
                    let firstHeight = textHeights.removeFirst()
                    let stepHeight = max(firstHeight / 2, self.circleRadius) + max((textHeights.first!) / 2, self.circleRadius) - self.lineMargin * 2 + verticalFontMargin - diameter // 线中间留10px空间,可以更改,看需求
                    stepHeights.append(stepHeight)
                }
            } else {//每个步骤高度一样
                var stepHeight: CGFloat = 0
                let textHeights = titleTextSizes.map {
                    $0.height
                }
                if self.numberOfSteps > 1 {
                    let topContentPadding = textHeights.first! / 2 > self.circleRadius ? textHeights.first! / 2 - self.circleRadius : 0
                    let bottomContentPadding = textHeights.last! / 2 > self.circleRadius ? textHeights.last! / 2 - self.circleRadius : 0

                    let totalStepHeight = self.containerLayer.frame.height - topContentPadding - bottomContentPadding - self.lineMargin * 2 * CGFloat(self.numberOfSteps - 1) - diameter * CGFloat(self.numberOfSteps)
                    stepHeight = totalStepHeight / CGFloat(self.numberOfSteps - 1)//单纯是线的长度
                }
                stepHeights = Array.init(repeating: stepHeight, count: self.numberOfSteps - 1)
            }

            for i in 0..<self.annularLayers.count {
                var y: CGFloat = 0
                if stepLineFitDescriptionText {
                    var topContentPadding: CGFloat = 0
                    let totalHeight = titleTextSizes.reduce(-verticalFontMargin) { (r, rect) -> CGFloat in
                        let textHeight = rect.height
                        return max(textHeight, diameter) + r + verticalFontMargin
                    }
                    topContentPadding = (self.containerLayer.frame.height - totalHeight) / 2 // 可以为负
                    var firstAnnulayerStartY: CGFloat = 0
                    if (titleTextSizes.first?.height ?? 0) / 2 - self.circleRadius > 0 {
                        firstAnnulayerStartY = topContentPadding + (titleTextSizes.first?.height ?? 0) / 2 - self.circleRadius
                    } else {
                        firstAnnulayerStartY = topContentPadding
                    }
                    y = firstAnnulayerStartY + CGFloat(i) * diameter + 2 * CGFloat(i) * self.lineMargin + stepHeights.prefix(upTo: i).reduce(0, +)

                    applyVerticalContentLayer(annularLayerY: y, index: i, stepHeights: stepHeights)//防止这里超界
                } else {
                    var firstAnnulayerStartY: CGFloat = 0
                    if (titleTextSizes.first?.height ?? 0) / 2 - self.circleRadius > 0 {
                        firstAnnulayerStartY = (titleTextSizes.first?.height ?? 0) / 2 - self.circleRadius
                    } else {
                        firstAnnulayerStartY = 0
                    }
                    let stepHeight = stepHeights.first!
                    y = firstAnnulayerStartY + CGFloat(i) * (stepHeight + self.lineMargin * 2 + diameter)
                    applyVerticalContentLayer(annularLayerY: y, index: i, stepHeights: stepHeights)//防止这里超界
                }
            }
        } else {
            let stepHeight = self.numberOfSteps <= 1 ?
                0 : (self.containerLayer.frame.height - self.lineMargin * 2 * CGFloat(self.numberOfSteps - 1) - diameter * CGFloat(self.numberOfSteps)) / CGFloat(self.numberOfSteps - 1)//单纯是线的长度
            stepHeights = Array.init(repeating: stepHeight, count: self.numberOfSteps - 1)
            for i in 0..<self.annularLayers.count {

                let y: CGFloat = self.numberOfSteps <= 1 ?
                    self.containerLayer.frame.height / 2.0 - self.circleRadius :
                    (diameter + stepHeight + 2 * lineMargin) * CGFloat(i)

                applyVerticalContentLayer(annularLayerY: y, index: i, stepHeights: stepHeights)
            }
        }

        //stepLineFitDescriptionText
        //1.高度弹性
        //先得出数组整组文字的长和高
        //选出最长一组,计算起始X的位置,记得加上之间的Margin
        //算出线的长短(文字高度+10)
        //得出文字的起始Y
        //2.高度相等
        //算出线的长短
        //先得出数组整组文字的长和高
        //得出文字起始位置
    }

    fileprivate func getTextRect(withIndex index:Int,maxWidth:CGFloat ) -> CGRect {
        let index = titles.firstIndex(of: text)
        
        let font = UIFont.systemFont(ofSize: stepDescriptionTextFontSize)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style]
        let attributesText = NSAttributedString(string: text, attributes: attributes)
        let size = attributesText.boundingRect(with: CGSize.init(width: maxFontWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil)
        return size
    }

    private func getHorizontalMaxTextRect() -> CGRect {
        let text = self.stepDescriptionTexts.reduce(self.stepDescriptionTexts.first ?? "") {
            return $0.count > $1.count ? $0 : $1
        }
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        return getTextRect(style, text)
    }

    fileprivate func applyVerticalContentLayer(annularLayerY: CGFloat, index: Int, stepHeights: [CGFloat]) {
        let startX = showStepDescriptionTexts ? self.circleRadius : self.containerLayer.frame.width / 2.0//综合加上字的长度
        let diameter = self.circleRadius * 2
        let annularLayer = self.annularLayers[index]
        annularLayer.frame = CGRect(x: startX - self.circleRadius, y: annularLayerY, width: diameter, height: diameter)
        self.applyAnnularStyle(annularLayer: annularLayer, index: index)
        annularLayer.step = index + 1
        annularLayer.updateStatus()

        if index < self.numberOfSteps - 1 {
            let lineLayer = self.lineLayers[index]
            let lineBackgroundWidth: CGFloat = self.lineStrokeWidth
            let lineX = showStepDescriptionTexts ? startX - self.lineStrokeWidth / 2 : self.containerLayer.frame.width / 2.0 - lineBackgroundWidth / 2.0
            let lineY = annularLayerY + diameter + self.lineMargin
            lineLayer.frame = CGRect(x: lineX, y: lineY, width: lineBackgroundWidth, height: stepHeights[index])
            lineLayer.isHorizontal = false
            self.applyLineStyle(lineLayer: lineLayer)
        }

        if showStepDescriptionTexts {
            var descriptionStartY: CGFloat = 0.0
            if stepLineFitDescriptionText {
                descriptionStartY = annularLayerY + self.circleRadius - titleTextSizes[index].height / 2
            } else {
                let textHeights = titleTextSizes.map {
                    $0.size.height
                }
                descriptionStartY = annularLayerY + self.circleRadius - textHeights[index] / 2
            }

            let descriptionStartX = startX + stepDescriptionTextMargin + self.circleRadius
            let descriptionLayer = self.descriptionTextLayers[index]
            self.applyDescriptionText(descriptionText: descriptionLayer, index: index)
            descriptionLayer.frame = CGRect.init(x: descriptionStartX, y: descriptionStartY, width: textSizes[index].size.width, height: textSizes[index].size.height)
            descriptionLayer.updateStatus()
        }
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

    private func applyStepText(annularLayer: AnnularLayer, index: Int) {
        annularLayer.showCircleText = true
        annularLayer.circleTextCompleteColor = self.circleTextCompleteColor
        annularLayer.circleTextIncompleteColor = self.circleTextIncompleteColor
        if stepCircleTexts.count > index {
            annularLayer.stepCircleText = stepCircleTexts[index]
        }
    }

    private func applyDescriptionText(descriptionText: DescriptionTextLayer, index: Int) {
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
            if showStepDescriptionTexts {
                self.descriptionTextLayers.forEach {
                    $0.transform = rotation180
                }
            }
        case .bottomToTop:
            let rotation180 = CATransform3DMakeRotation(CGFloat.pi, 1.0, 0.0, 0.0)
            self.containerLayer.transform = rotation180
            for annularLayer in self.annularLayers {
                annularLayer.transform = rotation180
            }
            if showStepDescriptionTexts {
                self.descriptionTextLayers.forEach {
                    $0.transform = rotation180
                }
            }
        default:
            self.containerLayer.transform = CATransform3DIdentity
            for annularLayer in self.annularLayers {
                annularLayer.transform = CATransform3DIdentity
            }
        }
    }

    private func setCurrentStep(step: Int) {
        for i in 0..<self.numberOfSteps {
            self.setAnnular(isFinished: i < step, isCurrent: i == step, index: i)
            self.setLine(isFinished: self.annularLayers[i].isFinished, isCurrent: self.annularLayers[i].isCurrent, index: i - 1)
            self.setDescriptionText(isFinished: self.annularLayers[i].isFinished, isCurrent: self.annularLayers[i].isCurrent, index: i)
        }
    }

    private func setAnnular(isFinished: Bool, isCurrent: Bool, index: Int) {
        self.annularLayers[index].isCurrent = isCurrent
        self.annularLayers[index].isFinished = isFinished
        self.annularLayers[index].currentStepAsIncomplete = self.currentStepAsIncomplete
        self.annularLayers[index].updateStatus()
    }

    private func setLine(isFinished: Bool, isCurrent: Bool, index: Int) {
        if index >= 0 {
            self.lineLayers[index].showAnimating = self.showLineAnimating
            self.lineLayers[index].currentStepAsIncomplete = currentStepAsIncomplete
            self.lineLayers[index].isFinished = isFinished
            self.lineLayers[index].isCurrent = isCurrent
            if isFinished {
                self.lineLayers[index].lineDashPattern = nil
            } else if isCurrent {
                self.lineLayers[index].lineDashPattern = currentStepAsIncomplete ? [NSNumber.init(value: self.lineImaginaryWidth), NSNumber.init(value: self.lineImaginaryMargin)] : nil
            } else {
                self.lineLayers[index].lineDashPattern = [NSNumber.init(value: self.lineImaginaryWidth), NSNumber.init(value: self.lineImaginaryMargin)]
            }
            self.lineLayers[index].updateStatus()
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
