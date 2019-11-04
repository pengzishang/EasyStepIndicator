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
//    override public var frame: CGRect {
//        didSet {
//            self.updateSubLayers()
//        }
//    }

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

    public var alignmentMode:AlignmentMode = .center
    
    //Line是否适应文字的高度,如果文字过多,建议开启,如果关闭的,Line的高度是与SuperView关联
//    public var stepLineFitDescriptionText = false {
//        didSet {
//            self.updateSubLayers()
//        }
//    }

    //步骤描述文字未完成时候颜色
    @IBInspectable public var stepDescriptionTextIncompleteColor: UIColor = UIColor.red {
        didSet {
            self.descriptionTextLayers.forEach {$0.config?.title.colors.incomplete = stepDescriptionTextIncompleteColor }
            self.updateSubLayers()
        }
    }

    //步骤描述文字完成时候颜色
    @IBInspectable public var stepDescriptionTextCompleteColor: UIColor = UIColor.green {
        didSet {
            self.descriptionTextLayers.forEach {$0.config?.title.colors.complete = stepDescriptionTextCompleteColor }
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
            self.descriptionTextLayers.forEach {$0.config?.title.fontSize = stepDescriptionTextFontSize }
            self.updateSubLayers()
        }
    }

//    private var maxContentWidth: CGFloat = UIScreen.main.bounds.width / 3

    private var maxFontHeight = 0

    private var showLineAnimating = true

    private var titleTextSizes: [CGSize] = []
    
    private var titles : [String] = []
    
    private var stepTexts: [String] = []
    
    // MARK: - Init
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
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

    fileprivate func getTextSize(index:Int, maxContentWidth:CGFloat = CGFloat.greatestFiniteMagnitude ,maxContentHeight: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        guard let _dataSource = self.dataSource else {
            return CGSize.zero
        }

        let oldTitle = titles[index]
        let newTitle = _dataSource.titleForStep(indicator: self, index: index)
        guard oldTitle != newTitle else{
            return CGSize.zero
        }

        let titleConfig = self.descriptionTextLayers[index].config

        let font = UIFont.systemFont(ofSize: titleConfig?.title.fontSize ?? self.stepDescriptionTextFontSize)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: titleConfig?.title.style ]
        let attributesText = NSAttributedString(string: (titleConfig?.title.content) ?? "", attributes: attributes as [NSAttributedString.Key : Any])
        let textSize = attributesText.boundingRect(with: CGSize.init(width: maxContentWidth, height: maxContentHeight), options: .usesLineFragmentOrigin, context: nil).size

        return textSize
    }
    
    fileprivate func circleRadius(_ annularLayer:AnnularLayer?) -> CGFloat {
        annularLayer?.config?.radius ?? self.circleRadius
    }
    
    fileprivate func circleDiameter(_ annularLayer:AnnularLayer?) -> CGFloat {
        self.circleRadius(annularLayer)
    }

    private func layoutHorizontal() {
        let maxContentWidth = UIScreen.main.bounds.width / 3

        for index in 0..<self.numberOfSteps {
            let size = self.getTextSize(index: index, maxContentWidth: maxContentWidth)
            self.titleTextSizes[index] = size
        }

        let titleMargins = self.annularLayers.map { $0.config?.titleMargin ?? self.stepDescriptionTextMargin }
        let titleHeights = self.titleTextSizes.map {$0.height}
        let radiuses = self.annularLayers.map {circleRadius($0)}
        let maxContentHeight = zip(zip(titleMargins, titleHeights).map(+), radiuses).map(+).max() ?? 0

        let startY = (self.containerLayer.frame.height - maxContentHeight) / 2 //整个图形的中轴Y
        
        var processLengths : [CGFloat] = {
            guard self.numberOfSteps > 1 else{
                return Array.init(repeating: 0, count: self.numberOfSteps - 1)
            }
            
            var processLength : CGFloat = 0
            if let _dataSource = self.dataSource {
                var totalLengthWithoutLine : CGFloat = 0
                for index in 0..<self.numberOfSteps {
                    let annularLayer = self.annularLayers[index]
                    totalLengthWithoutLine += circleDiameter(annularLayer)
                    if index < self.numberOfSteps - 1 {
                        let lineConfig = self.lineLayers[index].config
                        totalLengthWithoutLine +=  (lineConfig?.marginBetweenCircle ?? self.stepDescriptionTextMargin) * 2
                    }
                }
                switch self.alignmentMode {
                case .top:
                    let lastAnnularLayer = self.annularLayers.last
                    if self.titleTextSizes.last?.width ?? 0 > circleDiameter(lastAnnularLayer)  {
                        totalLengthWithoutLine += (self.titleTextSizes.last?.width ?? 0) - circleDiameter(lastAnnularLayer)
                    }
                case .center:
                    let firstAnnularLayer = self.annularLayers.first
                    let lastAnnularLayer = self.annularLayers.last
                    if self.titleTextSizes.first?.width ?? 0 > circleDiameter(firstAnnularLayer)  {
                        totalLengthWithoutLine += (self.titleTextSizes.first?.width ?? 0)/2 - circleRadius(firstAnnularLayer)
                    }
                    if self.titleTextSizes.last?.width ?? 0 > circleDiameter(lastAnnularLayer)  {
                        totalLengthWithoutLine += (self.titleTextSizes.last?.width ?? 0)/2 - circleRadius(lastAnnularLayer)
                    }
                case .centerWithAnnularStartAndAnnularEnd://不计首尾超界
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
            
            let annularStartX: CGFloat = {
                let firstAnnularLayer = self.annularLayers.first
                guard self.numberOfSteps > 1 else {
                    return self.containerLayer.frame.width / 2.0 - circleRadius(firstAnnularLayer)
                }
                
                var currentLength : CGFloat = 0
        
                switch self.alignmentMode  {
                case .top , .centerWithAnnularStartAndAnnularEnd:
                    if _index == 0 { return 0 }
                case .center:
                    if _index == 0 {
                        if circleDiameter(firstAnnularLayer) < self.titleTextSizes.first?.width ?? 0 {
                            return (self.titleTextSizes.first?.width ?? 0)/2 - circleRadius(firstAnnularLayer)
                        }
                        return 0
                    }
                }
        
                for __index in 0..<_index {
                    let _annularLayer = self.annularLayers[__index]
                    currentLength += circleRadius(_annularLayer)
                    currentLength += (self.lineLayers[__index].config?.marginBetweenCircle ?? self.lineMargin)*2
                    currentLength += processLengths[__index]
                }
                return currentLength
            }()
            let annularLayer = self.annularLayers[_index]
            let annularStartY: CGFloat = {
                guard self.numberOfSteps > 1 else {
                    return self.containerLayer.frame.height / 2.0 - (self.annularLayers.first?.config?.radius ?? self.circleRadius)
                }
                return startY - circleRadius(annularLayer)
            }()
            
            annularLayer.frame = CGRect(x: annularStartX, y: annularStartY, width: circleDiameter(annularLayer), height: circleDiameter(annularLayer))
            annularLayer.updateStatus()
            return CGPoint.init(x: annularStartX, y: annularStartY)
        }
        
        func layoutHorizontalLineLayer(_index: Int, annularPoint: CGPoint) {
            let annularLayer = self.annularLayers[_index]
            let lineLayer = self.lineLayers[_index]
            let lineStartX = annularPoint.x + circleDiameter(annularLayer) + (lineLayer.config?.marginBetweenCircle ?? self.lineMargin)
            let lineStartY = annularPoint.y + circleRadius(annularLayer) - (lineLayer.config?.strokeWidth ?? self.lineStrokeWidth)/2
            lineLayer.frame = CGRect.init(x: lineStartX, y: lineStartY, width: processLengths[_index], height: lineLayer.config?.strokeWidth ?? self.lineStrokeWidth)
            lineLayer.updateStatus()
        }
        
        func layoutHorizontalTitleLayer(_index: Int,annularPoint: CGPoint) {
            let descriptionTextLayer = self.descriptionTextLayers[_index]
            let annularLayer = self.annularLayers[_index]
            var descriptionStartX : CGFloat = annularPoint.x
            
            if self.alignmentMode == .center || self.alignmentMode == .centerWithAnnularStartAndAnnularEnd {
                descriptionStartX += circleRadius(annularLayer)
                descriptionStartX -= (self.titleTextSizes[_index].width )/2
            }
    
            let descriptionStartY = annularPoint.y + circleDiameter(annularLayer)
            descriptionTextLayer.frame = CGRect.init(x: descriptionStartX, y: descriptionStartY, width: maxContentWidth, height: self.titleTextSizes[_index].height + 2)//修正2px
            descriptionTextLayer.updateStatus()
        }
    
        for _index in 0..<self.numberOfSteps {
            let annularPoint = layoutHorizontalAnnularLayers(_index: _index)
            if _index < self.numberOfSteps - 1 {
                layoutHorizontalLineLayer(_index: _index, annularPoint: annularPoint)
            }
            if let _ = self.dataSource {
                layoutHorizontalTitleLayer(_index: _index, annularPoint: annularPoint)
            }
        }
    }

    private func layoutVertical() {

        let radiuses : [CGFloat] = self.annularLayers.map { circleRadius($0) }
        let titleMargins :[CGFloat] = self.annularLayers.map { $0.config?.titleMargin ?? self.stepDescriptionTextMargin }
        let maxContentWidths : [CGFloat] = zip(radiuses, titleMargins).map (+).map{self.containerLayer.frame.width - $0}

        for index in 0..<self.numberOfSteps {
            let size = self.getTextSize(index: index, maxContentWidth: maxContentWidths[index])
            self.titleTextSizes[index] = size
        }
        
        let startX : CGFloat = { //X中轴
            if let _ = self.dataSource {
                return radiuses.max() ?? 0
            } else {//靠左对齐
                return self.containerLayer.frame.width / 2.0
            }
        }()
        
        let startY : CGFloat = {
            let firstAnnularLayer = self.annularLayers.first
            switch self.alignmentMode {
            case .top, .centerWithAnnularStartAndAnnularEnd:
                return 0
            case .center:
                if circleDiameter(firstAnnularLayer) < self.titleTextSizes.first?.height ?? 0 {
                    return (self.titleTextSizes.first?.height ?? 0)/2 - circleDiameter(firstAnnularLayer)
                }
                return 0
            }
        }()
        
        var processLengths : [CGFloat] = {
            guard self.numberOfSteps > 1 else{
                return Array.init(repeating: 0, count: self.numberOfSteps - 1)
            }
            var processLength : CGFloat = 0
            if let _dataSource = self.dataSource {
                var totalLengthWithoutLine : CGFloat = 0
    
                if self.delegate?.shouldStepLineFitDescriptionText() ?? false {
                    let verticalFontMargin : CGFloat = 10
                    var textHeights = titleTextSizes.map {$0.height}
                    var comparedHeights = textHeights
                    for index in 0..<self.numberOfSteps {
                        let annularLayer = self.annularLayers[index]
                        if comparedHeights[index] < circleDiameter(annularLayer)  {
                            comparedHeights[index] = 0
                        } else {
                            comparedHeights[index] -= circleDiameter(annularLayer)
                        }
                    }
                    let heightPairs = zip(comparedHeights.prefix(upTo: comparedHeights.count - 1), comparedHeights.suffix(from: 1)).map { ( $0,$1)}
    
                    var processLengths : [CGFloat] = []
                    for index in 0..<self.numberOfSteps - 1 {
                        processLengths.append((heightPairs[index].0 + heightPairs[index].1)/2 - (self.lineLayers[index].config?.marginBetweenCircle ?? self.lineMargin) * 2 + verticalFontMargin)
                    }
                    return processLengths
                } else {
                    if self.alignmentMode == .center {
                        let firstAnnularLayer = self.annularLayers.first
                        let lastAnnularLayer = self.annularLayers.last

                        var topContentPadding : CGFloat = 0
                        var bottomContentPadding : CGFloat = 0
                        if self.titleTextSizes.first?.height ?? 0 > circleDiameter(firstAnnularLayer)  {
                            topContentPadding = (self.titleTextSizes.first?.height ?? 0)/2 - circleRadius(firstAnnularLayer)
                        }
                        if self.titleTextSizes.last?.height ?? 0 > circleDiameter(lastAnnularLayer)  {
                            bottomContentPadding = (self.titleTextSizes.last?.height ?? 0)/2 - circleRadius(lastAnnularLayer)
                        }
                        totalLengthWithoutLine += topContentPadding + bottomContentPadding
                    }
                    for index in 0..<self.numberOfSteps {
                        let annularLayer = self.annularLayers[index]

                        totalLengthWithoutLine += circleDiameter(annularLayer)
                        if index < self.numberOfSteps - 1 {
                            let lineConfig = self.lineLayers[index].config
                            totalLengthWithoutLine +=  (lineConfig?.marginBetweenCircle ?? self.stepDescriptionTextMargin) * 2
                        }
                    }
                    processLength = (self.containerLayer.frame.height - totalLengthWithoutLine) / CGFloat(self.numberOfSteps - 1)
                }
            } else {//Storyboard
                processLength = (self.containerLayer.frame.height - self.lineMargin * 2 - 2 * self.circleRadius) / CGFloat(self.numberOfSteps - 1)//每个步骤(一个圈加一整条线的宽度)
            }
            return Array.init(repeating: processLength, count: self.numberOfSteps - 1)
        }()
    
        func layoutVerticalAnnularLayers(_index: Int) -> CGPoint{
            let annularLayer = self.annularLayers[_index]
            let annularStartY: CGFloat = {
                guard self.numberOfSteps > 1 else {
                    return self.containerLayer.frame.height / 2.0 - circleDiameter(self.annularLayers[0])
                }
                
                var currentLength : CGFloat = 0
                switch self.alignmentMode  {
                case .top , .centerWithAnnularStartAndAnnularEnd:
                    if _index == 0 { return 0 }
                case .center:
                    if _index == 0 {
                        let firstAnnularLayer = self.annularLayers.first
                        if circleDiameter(firstAnnularLayer) < self.titleTextSizes.first?.height ?? 0 {
                            return (self.titleTextSizes.first?.height ?? 0)/2 - circleRadius(firstAnnularLayer)
                        }
                        return 0
                    }
                }
            
                for __index in 0..<_index {
                    currentLength += circleRadius(self.annularLayers[__index])
                    currentLength += (self.lineLayers[__index].config?.marginBetweenCircle ?? self.lineMargin)*2
                    currentLength += processLengths[__index]
                }
                return currentLength
            }()
            let annularStartX :CGFloat = {
                guard self.numberOfSteps > 1 else{
                    let firstAnnularLayer = self.annularLayers.first
                    return self.containerLayer.frame.width / 2.0 - circleRadius(firstAnnularLayer)
                }
                if let _ = self.dataSource {
                    let maxRadius =  self.annularLayers.max { circleRadius($0) > circleRadius($1)}?.config?.radius ?? self.circleRadius
                    return maxRadius - circleRadius(self.annularLayers[_index])
                } else {
                    return 0
                }
            }()
            
            annularLayer.frame = CGRect(x: annularStartX, y: annularStartY, width: circleDiameter(annularLayer), height: circleDiameter(annularLayer))
            annularLayer.updateStatus()
            return CGPoint.init(x: annularStartX, y: annularStartY)
        }
    
        func layoutVerticalLineLayer(_index: Int, annularPoint: CGPoint) {
            let annularLayer = self.annularLayers[_index]
            let lineLayer = self.lineLayers[_index]
            let lineStartY = annularPoint.y + circleDiameter(annularLayer) + (lineLayer.config?.marginBetweenCircle ?? self.lineMargin)
            let lineStartX = annularPoint.x + circleDiameter(annularLayer) - (lineLayer.config?.strokeWidth ?? self.lineStrokeWidth)/2
            lineLayer.frame = CGRect.init(x: lineStartX, y: lineStartY, width: lineLayer.config?.strokeWidth ?? self.lineStrokeWidth, height: processLengths[_index])
            lineLayer.updateStatus()
        }
    
        func layoutVerticalTitleLayer(_index: Int,annularPoint: CGPoint) {
            let descriptionTextLayer = self.descriptionTextLayers[_index]
            let annularLayer = self.annularLayers[_index]
            var descriptionStartY : CGFloat = annularPoint.y
            if self.alignmentMode == .center || self.alignmentMode == .centerWithAnnularStartAndAnnularEnd {
                descriptionStartY += circleRadius(annularLayer)
                descriptionStartY -= (self.titleTextSizes[_index].height )/2
            }
        
            let descriptionStartX = annularPoint.x + circleDiameter(annularLayer) + (annularLayer.config?.titleMargin ?? self.stepDescriptionTextMargin)
            descriptionTextLayer.frame = CGRect.init(x: descriptionStartX, y: descriptionStartY, width: maxContentWidths[_index], height: self.titleTextSizes[_index].height)//修正2px
            descriptionTextLayer.updateStatus()
        }
    
    
        for _index in 0..<self.numberOfSteps {
            let annularPoint = layoutVerticalAnnularLayers(_index: _index)
            if _index < self.numberOfSteps - 1 {
                layoutVerticalLineLayer(_index: _index, annularPoint: annularPoint)
            }
            if let _ = self.dataSource {
                layoutVerticalTitleLayer(_index: _index, annularPoint: annularPoint)
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

    private func applyDirection() {
        switch self.direction {
        case .rightToLeft:
            let rotation180 = CATransform3DMakeRotation(CGFloat.pi, 0.0, 1.0, 0.0)
            self.containerLayer.transform = rotation180
            for annularLayer in self.annularLayers {
                annularLayer.transform = rotation180
            }
            if self.dataSource != nil {
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
            if self.dataSource != nil {
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
        for _ in 0..<self.numberOfSteps {
            self.annularLayers[step].updateStatus()
            if step >= 0 {
                self.lineLayers[step].updateStatus()
            }
            self.descriptionTextLayers[step].updateStatus()
        }
    }
}
