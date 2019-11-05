//
//  EasyStepIndicator.swift
//  homesecurity
//
//  Created by DeshPeng on 2018/12/5.
//  Copyright © 2018年 Hub 6 Inc. All rights reserved.
//

import UIKit

@IBDesignable
public class EasyStepIndicator: UIView {
    
    weak var dataSource : EasyStepIndicatorDataSource?
    weak var delegate : EasyStepIndicatorDelegate?
    
    // Variables
    private var annularLayers = [AnnularLayer]()
    private var lineLayers = [LineLayer]()
    private var descriptionTextLayers = [DescriptionTextLayer]()
    private let containerLayer = CALayer()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updateSubLayers()
    }
    
    // MARK: - Properties
    
    //总步骤数量
    @IBInspectable public var numberOfSteps: Int = 5 {
        didSet {
            self.createSteps()
        }
    }
    //当前步骤
    @IBInspectable public var currentStep: Int = 0 {
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
    public var direction: Direction = .leftToRight {
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
            self.direction = Direction(rawValue: value)!
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
    
    /// 对齐模式
    public var alignmentMode:AlignmentMode = .center
    
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
    
    private var showLineAnimating = true
    
    private var titleTextSizes: [CGSize] = []
    
    // MARK: - Init
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(frame: CGRect,numberOfSteps:Int) {
        super.init(frame: frame)
        self.numberOfSteps = numberOfSteps
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
            
            let stepConfig = StepConfig.init(radius: self.circleRadius, stepIndex: index)
            let annularLayer = AnnularLayer.init(config: stepConfig)
            annularLayer.indicator = self
            self.containerLayer.addSublayer(annularLayer)
            self.annularLayers.append(annularLayer)
            
            if (index < self.numberOfSteps - 1) {
                let lineConfig = LineConfig.init(processIndex: index)
                let lineLayer = LineLayer.init(config: lineConfig, target: self)
                self.containerLayer.addSublayer(lineLayer)
                self.lineLayers.append(lineLayer)
            }
            let titleConfig = TitleConfig.init(stepIndex: index)
            let descriptionLayer = DescriptionTextLayer.init(titleConfig: titleConfig, target: self)
            self.containerLayer.addSublayer(descriptionLayer)
            self.descriptionTextLayers.append(descriptionLayer)
        }
        
        self.layer.addSublayer(self.containerLayer)
        self.updateSubLayers()
    }
    
    private func updateData() {
        for index in 0..<self.numberOfSteps {
            let character = self.dataSource?.characterForStep(indicator: self, index: index)
            let title = self.dataSource?.titleForStep(indicator: self, index: index)
            if var stepConfig = self.delegate?.stepConfigForStep(indicator: self, index: index, config: &self.annularLayers[index].config!) {
                stepConfig.stepText.content = character
                self.annularLayers[index].config = stepConfig
            }
            self.annularLayers[index].config?.stepText.content = character
            if (index < self.numberOfSteps - 1) {
                if let lineConfig = self.delegate?.lineConfigForProcess(indicator: self, index: index, config: &self.lineLayers[index].config!) {
                    self.lineLayers[index].config = lineConfig
                }
            }
            if var titleConfig = self.delegate?.titleConfigForStep(indicator: self, index: index, config: &self.descriptionTextLayers[index].config!) {
                titleConfig.title.content = title
                self.descriptionTextLayers[index].config = titleConfig
            }
            self.descriptionTextLayers[index].config?.title.content = title
        }
    }
    
    private func updateSubLayers() {
        self.containerLayer.frame = self.layer.bounds
        self.updateData()
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
        
        let newTitle = _dataSource.titleForStep(indicator: self, index: index)
        let titleConfig = self.descriptionTextLayers[index].config
        
        let font = UIFont.systemFont(ofSize: titleConfig?.title.fontSize ?? self.stepDescriptionTextFontSize)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: titleConfig?.title.style ]
        let attributesText = NSAttributedString(string: newTitle, attributes: attributes as [NSAttributedString.Key : Any])
        let textSize = attributesText.boundingRect(with: CGSize.init(width: maxContentWidth, height: maxContentHeight), options: .usesLineFragmentOrigin, context: nil).size
        
        return textSize
    }
    
    fileprivate func circleRadius(_ annularLayer:AnnularLayer?) -> CGFloat {
        annularLayer?.config?.radius ?? self.circleRadius
    }
    
    fileprivate func circleDiameter(_ annularLayer:AnnularLayer?) -> CGFloat {
        self.circleRadius(annularLayer) * 2
    }
    
    private func layoutHorizontal() {
        let maxContentWidth = UIScreen.main.bounds.width / 3
        var maxContentHeight : CGFloat = 0
        if let _ = self.dataSource {
            self.titleTextSizes.removeAll()
            for index in 0..<self.numberOfSteps {
                let size = self.getTextSize(index: index, maxContentWidth: maxContentWidth)
                self.titleTextSizes.append(size)
                self.descriptionTextLayers[index].titleSize = size
            }
            
            let titleMargins = self.annularLayers.map { $0.config?.titleMargin ?? self.stepDescriptionTextMargin }
            let titleHeights = self.titleTextSizes.map {$0.height}
            let radiuses = self.annularLayers.map {circleRadius($0)}
            maxContentHeight = zip(zip(titleMargins, titleHeights).map(+), radiuses).map(+).max() ?? 0
        }
        
        let startY = (self.containerLayer.frame.height - maxContentHeight) / 2 //整个图形的中轴Y
        
        var processLengths : [CGFloat] = {
            guard self.numberOfSteps > 1 else{
                return Array.init(repeating: 0, count: self.numberOfSteps - 1)
            }
            
            var processLength : CGFloat = 0
            if let _dataSource = self.dataSource {
                //TODO : shouldStepLineFitDescriptionText
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
                processLength = (self.containerLayer.frame.width - self.lineMargin * 2 * CGFloat(self.numberOfSteps - 1) - 2 * self.circleRadius * CGFloat(self.numberOfSteps)) / CGFloat(self.numberOfSteps - 1)//每个步骤(一个圈加一整条线的宽度)
            }
            return Array.init(repeating: processLength, count: self.numberOfSteps - 1)
        }()
        
        func layoutHorizontalAnnularLayers(_index: Int) -> CGPoint{
            let annularStartX: CGFloat = {
                let firstAnnularLayer = self.annularLayers.first
                guard self.numberOfSteps > 1 else {
                    return self.containerLayer.frame.midX - circleRadius(firstAnnularLayer)
                }
                
                var currentLength : CGFloat = 0
                if self.alignmentMode == .center {
                    if circleDiameter(firstAnnularLayer) < self.titleTextSizes.first?.width ?? 0 {
                        currentLength += (self.titleTextSizes.first?.width ?? 0)/2 - circleRadius(firstAnnularLayer)
                    }
                }
                
                for __index in 0..<_index {
                    let _annularLayer = self.annularLayers[__index]
                    currentLength += circleDiameter(_annularLayer)
                    currentLength += (self.lineLayers[__index].config?.marginBetweenCircle ?? self.lineMargin)*2
                    currentLength += processLengths[__index]
                }
                return currentLength
            }()
            let annularLayer = self.annularLayers[_index]
            let annularStartY: CGFloat = {
                guard self.numberOfSteps > 1 else {
                    return self.containerLayer.frame.midY - circleRadius(self.annularLayers[0])
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
            
            let descriptionStartY = annularPoint.y + circleDiameter(annularLayer) + (annularLayer.config?.titleMargin ?? self.stepDescriptionTextMargin)
            descriptionTextLayer.frame = CGRect.init(x: descriptionStartX, y: descriptionStartY, width: self.titleTextSizes[_index].width, height: self.titleTextSizes[_index].height)
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
        let diameters : [CGFloat] = self.annularLayers.map { circleDiameter($0) }
        let maxDiameter = diameters.max() ?? self.circleRadius * 2
        let titleMargins :[CGFloat] = self.annularLayers.map { $0.config?.titleMargin ?? self.stepDescriptionTextMargin }
        let maxContentWidths : [CGFloat] = titleMargins.map{$0 + maxDiameter}.map{self.containerLayer.frame.width - $0}
        if let _ = self.dataSource {
            self.titleTextSizes.removeAll()
            for index in 0..<self.numberOfSteps {
                let size = self.getTextSize(index: index, maxContentWidth: maxContentWidths[index])
                self.titleTextSizes.append(size)
            }
        }
        
        let startX : CGFloat = { //X中轴
            if let _ = self.dataSource {//靠左对齐
                return maxDiameter/2
            } else {
                return self.containerLayer.frame.width / 2.0
            }
        }()
        
        let startY : CGFloat = {
            let firstAnnularLayer = self.annularLayers.first
            if self.alignmentMode == .center {
                if circleDiameter(firstAnnularLayer) < self.titleTextSizes.first?.height ?? 0 {
                    return (self.titleTextSizes.first?.height ?? 0)/2 - circleRadius(firstAnnularLayer)
                }
            }
            return 0
        }()
        
        var processLengths : [CGFloat] = {
            //TODO : Top和fit模式下,线长问题,圆圈坐标问题
            
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
                processLength = (self.containerLayer.frame.height - self.lineMargin * 2 * CGFloat(self.numberOfSteps - 1) - 2 * self.circleRadius * CGFloat(self.numberOfSteps)) / CGFloat(self.numberOfSteps - 1)//每个步骤(一个圈加一整条线的宽度)
            }
            return Array.init(repeating: processLength, count: self.numberOfSteps - 1)
        }()
        
        func layoutVerticalAnnularLayers(_index: Int) -> CGPoint{
            let annularLayer = self.annularLayers[_index]
            let annularStartY: CGFloat = {
                let firstAnnularLayer = self.annularLayers.first
                guard self.numberOfSteps > 1 else {
                    return self.containerLayer.frame.height / 2.0 - circleDiameter(self.annularLayers[0])
                }
                
                var currentLength : CGFloat = 0
                
                if self.alignmentMode == .center {
                    if circleDiameter(firstAnnularLayer) < self.titleTextSizes.first?.height ?? 0 {
                        currentLength += (self.titleTextSizes.first?.height ?? 0)/2 - circleRadius(firstAnnularLayer)
                    }
                }
                
                for __index in 0..<_index {
                    currentLength += circleDiameter(self.annularLayers[__index])
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
                    return startX - circleRadius(self.annularLayers[_index])
                } else { // Storyboard
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
            let lineStartX = annularPoint.x + circleRadius(annularLayer) - (lineLayer.config?.strokeWidth ?? self.lineStrokeWidth)/2
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
            descriptionTextLayer.frame = CGRect.init(x: descriptionStartX, y: descriptionStartY, width: self.titleTextSizes[_index].width, height: self.titleTextSizes[_index].height)//修正2px
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
        self.delegate?.didChangeStep(indicator: self, index: step)
        for index in 0..<self.numberOfSteps {
            self.annularLayers[index].updateStatus()
            if index < self.numberOfSteps - 1 {
                self.lineLayers[index].showAnimating = self.showLineAnimating
                self.lineLayers[index].updateStatus()
            }
            self.descriptionTextLayers[index].updateStatus()
        }
    }
}
