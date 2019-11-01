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
            self.annularLayers.forEach {$0.config?.annular.dashPatternComplete.width = circleAnnularLineDashWidth}
            self.annularLayers.forEach {$0.config?.annular.dashPatternIncomplete.width = circleAnnularLineDashWidth}
            self.updateSubLayers()
        }
    }
    //指示圆框虚线间隔
    @IBInspectable public var circleAnnularLineDashMargin: Float = 3 {
        didSet {
            self.annularLayers.forEach {$0.config?.annular.dashPatternComplete.margin = circleAnnularLineDashMargin}
            self.annularLayers.forEach {$0.config?.annular.dashPatternIncomplete.margin = circleAnnularLineDashMargin}
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
            self.lineLayers.forEach {$0.config?.dashPatternComplete.margin = lineImaginaryMargin}
            self.lineLayers.forEach {$0.config?.dashPatternIncomplete.margin = lineImaginaryMargin}
            self.updateSubLayers()
        }
    }
    //指向线条小虚线宽度
    @IBInspectable public var lineImaginaryWidth: Float = 5 {
        didSet {
            self.lineLayers.forEach {$0.config?.dashPatternComplete.width = lineImaginaryWidth}
            self.lineLayers.forEach {$0.config?.dashPatternIncomplete.width = lineImaginaryWidth}
            self.updateSubLayers()
        }
    }

    //增长方向
    public var direction: EasyStepIndicatorDirection = .leftToRight {
        didSet {
//            self.lineLayers.forEach { $0.config?.isHorizontal = (direction == .leftToRight||direction == .rightToLeft) }
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

    public var firstHeadingAligmentMode :FirstHeadingAlignmentMode = .center
    
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
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    
    public func reload() {
        self.createSteps()
    }
    
    private func createSteps() {

        self.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        self.containerLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })

        self.annularLayers.removeAll()
        self.lineLayers.removeAll()
        self.descriptionTextLayers.removeAll()

        assert(self.numberOfSteps > 0, "步骤数必须大于0")

        for index in 0..<self.numberOfSteps {
            
            let character = self.dataSource?.characterForStep(indicator: self, index: index)
            var stepConfig = StepConfig.init(radius: self.circleRadius, stepIndex: index, text: character)
            if let _delegate = self.delegate {
                stepConfig = _delegate.stepConfigForStep(indicator: self, index: index, config: stepConfig)
            }
            let annularLayer = AnnularLayer.init(config: stepConfig)
            annularLayer.indicator = self
            self.containerLayer.addSublayer(annularLayer)
            self.annularLayers.append(annularLayer)

            if (index < self.numberOfSteps - 1) {
                var lineConfig = LineConfig.init(processIndex: index)
                if let _delegate = self.delegate {
                    lineConfig = _delegate.lineConfigForProcess(indicator: self, index: index, config: lineConfig)
                }
                let lineLayer = LineLayer.init(config: lineConfig)
                lineLayer.indicator = self
                self.containerLayer.addSublayer(lineLayer)
                self.lineLayers.append(lineLayer)
            }
            let title = self.dataSource?.titleForStep(indicator: self, index: index)
            var titleConfig = TitleConfig.init(stepIndex: index, title: title)
            if let _delegate = self.delegate {
                titleConfig = _delegate.titleConfigForStep(indicator: self, index: index, config: titleConfig)
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
                titles.append(title )
            }
            if oldTitles != titles {
                titleTextSizes.removeAll()
                for index in 0..<self.numberOfSteps {
                    let size = self.getTextRect(withIndex: index, maxWidth: CGFloat.greatestFiniteMagnitude).size
                    let stepConfig = self.annularLayers[index].config
                    let fontMargin = stepConfig?.titleMargin
                    maxContentHeight = max(size.height + (fontMargin ?? 3) ,maxContentHeight)
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
                    let stepConfig = self.annularLayers[index].config
                    totalLengthWithoutLine += (stepConfig?.radius ?? self.circleRadius) * 2
                    if index < self.numberOfSteps - 1 {
                        let lineConfig = self.lineLayers[index].config
                        totalLengthWithoutLine +=  (lineConfig?.marginBetweenCircle ?? self.stepDescriptionTextMargin) * 2
                    }
                }
                switch self.firstHeadingAligmentMode {
                case .top:
                    let lastStepConfig = self.annularLayers.last?.config
                    if self.titleTextSizes.last?.width ?? 0 > 2 * (lastStepConfig?.radius ?? self.circleRadius)  {
                        totalLengthWithoutLine += (self.titleTextSizes.last?.width ?? 0) - 2 * (lastStepConfig?.radius ?? self.circleRadius)
                    }
                case .center:
                    let firstStepConfig = self.annularLayers.first?.config
                    let lastStepConfig = self.annularLayers.last?.config
                    if self.titleTextSizes.first?.width ?? 0 > 2 * (firstStepConfig?.radius ?? self.circleRadius)  {
                        totalLengthWithoutLine += (self.titleTextSizes.first?.width ?? 0)/2 - (firstStepConfig?.radius ?? self.circleRadius)
                    }
                    if self.titleTextSizes.last?.width ?? 0 > 2 * (lastStepConfig?.radius ?? self.circleRadius)  {
                        totalLengthWithoutLine += (self.titleTextSizes.last?.width ?? 0)/2 - (lastStepConfig?.radius ?? self.circleRadius)
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
                self.lineLayers[index].config?.processLength = processLengths[index]
            }
        }
        
        func layoutHorizontalAnnularLayers(_index: Int) -> CGPoint{
            let annularLayer = self.annularLayers[_index]
            let annularStartX: CGFloat = {
                guard self.numberOfSteps > 1 else {
                    return self.containerLayer.frame.width / 2.0 - (self.annularLayers.first?.config?.radius ?? self.circleRadius)
                }
        
                let firstStepConfig = self.annularLayers.first?.config
                var currentLength : CGFloat = 0
        
                switch self.firstHeadingAligmentMode  {
                case .top , .centerWithAnnularTopStart:
                    if _index == 0 { return 0 }
                case .center:
                    if _index == 0 {
                        if (firstStepConfig?.radius ?? self.circleRadius) * 2 < self.titleTextSizes.first?.width ?? 0 {
                            return (self.titleTextSizes.first?.width ?? 0)/2 - (firstStepConfig?.radius ?? self.circleRadius)
                        }
                        return 0
                    }
                }
        
                for __index in 0..<_index {
                    currentLength += self.annularLayers[__index].config?.radius ?? self.circleRadius
                    currentLength += (self.lineLayers[__index].config?.marginBetweenCircle ?? self.lineMargin)*2
                    currentLength += processLengths[__index]
                }
                return currentLength
            }()
            let annularStartY = startY - self.circleRadius
            let diameter = (self.annularLayers[_index].config?.radius ?? self.circleRadius) * 2
            annularLayer.frame = CGRect(x: annularStartX, y: annularStartY, width: diameter, height: diameter)
            annularLayer.updateStatus()
            return CGPoint.init(x: annularStartX, y: annularStartY)
        }
        
        func layoutHorizontalLineLayer(_index: Int, annularPoint: CGPoint) {
                let lineLayer = self.lineLayers[_index]
            let lineStartX = annularPoint.x + (lineLayer.config?.marginBetweenCircle ?? self.lineMargin)
            let lineStartY = annularPoint.y - (lineLayer.config?.strokeWidth ?? self.lineStrokeWidth)/2
                
                lineLayer.frame = CGRect.init(x: lineStartX, y: lineStartY, width: processLengths[_index], height: lineLayer.config?.strokeWidth ?? self.lineStrokeWidth)
                lineLayer.updateStatus()
        }
        
        func layoutHorizontalTitleLayer(_index: Int,annularPoint: CGPoint) {
            let descriptionTextLayer = self.descriptionTextLayers[_index]
            let annularLayer = self.annularLayers[_index]
            var descriptionStartX : CGFloat = annularPoint.x
            if self.firstHeadingAligmentMode == .center {
                if (annularLayer.config?.radius ?? self.circleRadius) * 2 < self.titleTextSizes[_index].width {
                    descriptionStartX -= (self.titleTextSizes[_index].width )/2
                }
            }
    
            let descriptionStartY = annularPoint.y + 2 * (annularLayer.config?.radius ?? self.circleRadius)
            descriptionTextLayer.frame = CGRect.init(x: descriptionStartX, y: descriptionStartY, width: maxFontWidth, height: self.titleTextSizes[_index].height + 2)//修正2px
            descriptionTextLayer.updateStatus()
        }
    
        for _index in 0..<self.numberOfSteps {
            let annularPoint = layoutHorizontalAnnularLayers(_index: _index)
            layoutHorizontalTitleLayer(_index: _index, annularPoint: annularPoint)
            if _index < self.numberOfSteps - 1 {
                layoutHorizontalLineLayer(_index: _index, annularPoint: annularPoint)
            }
        }
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
            self.annularLayers[step].updateStatus()
            if step >= 0 {
                self.lineLayers[step].updateStatus()
            }
            self.descriptionTextLayers[step].updateStatus()
        }
    }
}
