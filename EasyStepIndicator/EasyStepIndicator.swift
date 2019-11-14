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
	
	weak var dataSource: EasyStepIndicatorDataSource?
	weak var delegate: EasyStepIndicatorDelegate?
	
	// Variables
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.updateSubLayers()
	}
	
	// MARK: - Properties
	
	public override var frame: CGRect {
		didSet {
			if self.numberOfSteps > 0 {
				self.updateSubLayers()
			}
		}
	}
	
	//总步骤数量
	@IBInspectable public var numberOfSteps: Int = 0 {
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
			self.annularLayers.forEach {
				$0.config.radius = circleRadius
			}
			self.updateSubLayers()
		}
	}
	//指示圆框未完成时候的颜色
	@IBInspectable public var circleAnnularIncompleteColor: UIColor = defaultIncompleteColor {
		didSet {
			self.annularLayers.forEach {
				$0.config.annular.colors.incomplete = circleAnnularIncompleteColor
			}
			self.updateSubLayers()
		}
	}
	//指示圆框完成时候的颜色
	@IBInspectable public var circleAnnularCompleteColor: UIColor = defaultCompleteColor {
		didSet {
			self.annularLayers.forEach {
				$0.config.annular.colors.complete = circleAnnularCompleteColor
			}
			self.updateSubLayers()
		}
	}
	//指示圆框线条的宽度
	@IBInspectable public var circleStrokeWidth: CGFloat = 1.0 {
		didSet {
			self.annularLayers.forEach {
				$0.config.annular.strokeWidth = circleStrokeWidth
			}
			self.updateSubLayers()
		}
	}
	//指示圆框虚线长度
	@IBInspectable public var circleAnnularLineDashWidth: Float = 3 {
		didSet {
			self.annularLayers.forEach {
				$0.config.annular.dashPatternComplete.width = circleAnnularLineDashWidth
			}
			self.annularLayers.forEach {
				$0.config.annular.dashPatternIncomplete.width = circleAnnularLineDashWidth
			}
			self.updateSubLayers()
		}
	}
	//指示圆框虚线间隔
	@IBInspectable public var circleAnnularLineDashMargin: Float = 3 {
		didSet {
			self.annularLayers.forEach {
				$0.config.annular.dashPatternComplete.margin = circleAnnularLineDashMargin
			}
			self.annularLayers.forEach {
				$0.config.annular.dashPatternIncomplete.margin = circleAnnularLineDashMargin
			}
			self.updateSubLayers()
		}
	}
	//圆内未完成时候的颜色
	@IBInspectable public var circleTintIncompleteColor: UIColor = defaultIncompleteColor {
		didSet {
			self.annularLayers.forEach {
				$0.config.tint.colors.incomplete = circleTintIncompleteColor
			}
			self.updateSubLayers()
		}
	}
	//圆内完成时候的颜色
	@IBInspectable public var circleTintCompleteColor: UIColor = defaultCompleteColor {
		didSet {
			self.annularLayers.forEach {
				$0.config.tint.colors.complete = circleTintCompleteColor
			}
			self.updateSubLayers()
		}
	}
	//指向线条未完成的颜色
	@IBInspectable public var lineIncompleteColor: UIColor = defaultIncompleteColor {
		didSet {
			self.lineLayers.forEach {
				$0.config.colors.incomplete = lineIncompleteColor
			}
			self.updateSubLayers()
		}
	}
	//指向线条完成的颜色
	@IBInspectable public var lineCompleteColor: UIColor = defaultCompleteColor {
		didSet {
			self.lineLayers.forEach {
				$0.config.colors.complete = lineCompleteColor
			}
			self.updateSubLayers()
		}
	}
	//指向线条离圆形的初始距离
	@IBInspectable public var lineMargin: CGFloat = 0.0 {
		didSet {
			self.lineLayers.forEach {
				$0.config.marginBetweenCircle = lineMargin
			}
			self.updateSubLayers()
		}
	}
	//指向线条宽度
	@IBInspectable public var lineStrokeWidth: CGFloat = 4.0 {
		didSet {
			self.lineLayers.forEach {
				$0.config.strokeWidth = lineStrokeWidth
			}
			self.updateSubLayers()
		}
	}
	
	//指向线条虚线间隔
	@IBInspectable public var lineImaginaryMargin: Float = 1 {
		didSet {
			self.lineLayers.forEach {
				$0.config.dashPatternComplete.margin = lineImaginaryMargin
			}
			self.lineLayers.forEach {
				$0.config.dashPatternIncomplete.margin = lineImaginaryMargin
			}
			self.updateSubLayers()
		}
	}
	//指向线条小虚线宽度
	@IBInspectable public var lineImaginaryWidth: Float = 5 {
		didSet {
			self.lineLayers.forEach {
				$0.config.dashPatternComplete.width = lineImaginaryWidth
			}
			self.lineLayers.forEach {
				$0.config.dashPatternIncomplete.width = lineImaginaryWidth
			}
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
			self.direction.rawValue
		}
		set {
			let value = newValue > 3 ? 0 : newValue
			self.direction = Direction(rawValue: value)!
		}
	}
	
	//圆形内描述文字未完成时候颜色
	@IBInspectable public var circleTextIncompleteColor: UIColor = defaultIncompleteColor {
		didSet {
			self.annularLayers.forEach {
				$0.config.stepText.colors.incomplete = circleTextIncompleteColor
			}
			self.updateSubLayers()
		}
	}
	
	//圆形内描述文字完成时候颜色
	@IBInspectable public var circleTextCompleteColor: UIColor = defaultCompleteColor {
		didSet {
			self.annularLayers.forEach {
				$0.config.stepText.colors.complete = circleTextCompleteColor
			}
			self.updateSubLayers()
		}
	}
	
	/// 对齐模式
	public var alignmentMode: AlignmentMode = .center {
		didSet {
			self.updateSubLayers()
		}
	}
	
	//步骤描述文字未完成时候颜色
	@IBInspectable public var stepDescriptionTextIncompleteColor: UIColor = UIColor.red {
		didSet {
			self.descriptionTextLayers.forEach {
				$0.config.title.colors.incomplete = stepDescriptionTextIncompleteColor
			}
			self.updateSubLayers()
		}
	}
	
	//步骤描述文字完成时候颜色
	@IBInspectable public var stepDescriptionTextCompleteColor: UIColor = UIColor.green {
		didSet {
			self.descriptionTextLayers.forEach {
				$0.config.title.colors.complete = stepDescriptionTextCompleteColor
			}
			self.updateSubLayers()
		}
	}
	
	//Indicator和Description之间Margin
	@IBInspectable public var stepDescriptionTextMargin: CGFloat = 3 {
		didSet {
			self.annularLayers.forEach {
				$0.config.titleMargin = stepDescriptionTextMargin
			}
			self.updateSubLayers()
		}
	}
	
	//步骤描述文字的大小
	@IBInspectable public var stepDescriptionTextFontSize: CGFloat = 18 {
		didSet {
			self.descriptionTextLayers.forEach {
				$0.config.title.fontSize = stepDescriptionTextFontSize
			}
			self.updateSubLayers()
		}
	}
	
	@IBInspectable public var freezeZone: UIEdgeInsets {
		set {
			_freezeZone = newValue
			if self.direction == .rightToLeft {
				_freezeZone.left = newValue.right
				_freezeZone.right = newValue.left
			} else if self.direction == .bottomToTop {
				_freezeZone.bottom = newValue.top
				_freezeZone.top = newValue.bottom
			}
			self.updateSubLayers()
		}
		get {
			_freezeZone
		}
	}
	//描述文字间最小间距
	public var minContentMargin: CGFloat = 5 {
		didSet {
			self.updateSubLayers()
		}
	}
	
	public var maxContentWidth: CGFloat = CGFloat.greatestFiniteMagnitude {
		didSet {
			self.updateSubLayers()
		}
	}
	
	public var contentScrollView = UIScrollView()
	
    private var processLayers = [ProcessLayer]()
    private var oppositeLayers = [TitleOppositeLayer]()
	private var annularLayers = [AnnularLayer]()
	private var lineLayers = [LineLayer]()
	private var descriptionTextLayers = [DescriptionTextLayer]()
	private let containerLayer = CALayer()
	private var _freezeZone: UIEdgeInsets = UIEdgeInsets.zero
	private var showLineAnimating = true
	private var titleTextSizes: [CGSize] = []
	private var titleIndentSizes: [CGSize] = []
    private var titleOppositeViewSizes: [CGSize] = []
    private var processViewSizes: [CGSize] = []
	private var maxContentWidths: [CGFloat] = []
	
	// MARK: - Init
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	// MARK: - Functions
	
	public func reload() {
		self.updateSubLayers()
	}
	
	private func createSteps() {
		self.contentScrollView.removeFromSuperview()
		self.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
		self.containerLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })
		
		self.annularLayers.removeAll()
		self.lineLayers.removeAll()
		self.descriptionTextLayers.removeAll()
		self.titleTextSizes.removeAll()
		self.titleIndentSizes.removeAll()
        self.oppositeLayers.removeAll()
        self.processLayers.removeAll()
		
		assert(self.numberOfSteps > 0, "步骤数必须大于0")
		assert(self.freezeZone.left + self.freezeZone.right < self.bounds.width, "freeze太大了")
		assert(self.freezeZone.top + self.freezeZone.bottom < self.bounds.height, "freeze太大了")
		
		for index in 0..<self.numberOfSteps {
			self.titleTextSizes.append(CGSize.zero)
			self.titleIndentSizes.append(CGSize.zero)

			if (index < self.numberOfSteps - 1) {
				let lineConfig = LineConfig.init(processIndex: index)
				let lineLayer = LineLayer.init(config: lineConfig, target: self)
                let processLayer = ProcessLayer.init(processIndex: index)
                self.processLayers.append(processLayer)
                self.containerLayer.addSublayer(processLayer)
				self.containerLayer.addSublayer(lineLayer)
				self.lineLayers.append(lineLayer)
			}
            
            let stepConfig = StepConfig.init(radius: self.circleRadius, stepIndex: index)
            let annularLayer = AnnularLayer.init(config: stepConfig, target: self)
            let oppositeLayer = TitleOppositeLayer.init(stepIndex: index)
            self.oppositeLayers.append(oppositeLayer)
            self.containerLayer.addSublayer(oppositeLayer)
            self.containerLayer.addSublayer(annularLayer)
            self.annularLayers.append(annularLayer)
            
			let titleConfig = TitleConfig.init(stepIndex: index)
			let descriptionLayer = DescriptionTextLayer.init(titleConfig: titleConfig, target: self)
			self.containerLayer.addSublayer(descriptionLayer)
			self.descriptionTextLayers.append(descriptionLayer)
		}
		self.addSubview(self.contentScrollView)
		self.contentScrollView.layer.addSublayer(self.containerLayer)
		self.updateSubLayers()
	}
	
	private func updateData() {
        self.titleOppositeViewSizes.removeAll()
        self.processViewSizes.removeAll()
		for index in 0..<self.numberOfSteps {
			let character = self.dataSource?.characterForStep(indicator: self, index: index)
			let title = self.dataSource?.titleForStep(indicator: self, index: index)
            
            if let oppositeView = self.dataSource?.oppositeViewForStep(indicator: self, index: index) {
                self.annularLayers[index].config.oppositeView = oppositeView
                self.titleOppositeViewSizes.append(oppositeView.frame.size)
            } else {
                self.annularLayers[index].config.oppositeView = nil
                self.titleOppositeViewSizes.append(CGSize.zero)
            }
			self.delegate?.stepConfigForStep(indicator: self, index: index, config: &self.annularLayers[index].config)
            
			self.annularLayers[index].config.stepText.content = character
			if (index < self.numberOfSteps - 1) {
                if let view = self.dataSource?.viewForProcess(indicator: self, index: index) {
                    self.lineLayers[index].config.processView = view
                    self.processViewSizes.append(view.frame.size)
                } else {
                    self.lineLayers[index].config.processView = nil
                    self.processViewSizes.append(CGSize.zero)
                }
				self.delegate?.lineConfigForProcess(indicator: self, index: index, config: &self.lineLayers[index].config)
			}
			self.delegate?.titleConfigForStep(indicator: self, index: index, config: &self.descriptionTextLayers[index].config)
			self.descriptionTextLayers[index].config.title.content = title
		}
	}
	
	private func updateSubLayers() {
		self.updateData()
		self.contentScrollView.frame = self.layer.bounds
		if self.direction == .leftToRight || self.direction == .rightToLeft {
			let contentWidth = self.getContentTotalWidth()
			self.contentScrollView.contentSize = CGSize.init(width: contentWidth + self.freezeZone.left + self.freezeZone.right, height: self.bounds.height)//Todo
		} else {
			let contentHeight = self.getTotalContentHeight()
			self.contentScrollView.contentSize = CGSize.init(width: self.bounds.width, height: contentHeight + self.freezeZone.top + self.freezeZone.bottom)
		}
		self.containerLayer.frame = CGRect.init(origin: self.bounds.origin, size: self.contentScrollView.contentSize)
		if self.direction == .leftToRight || self.direction == .rightToLeft {
			self.layoutHorizontal()
		} else {
			self.layoutVertical()
		}
		self.applyDirection()
	}
	
	func getContentTotalWidth() -> CGFloat {
		guard let _ = self.dataSource else {
            return self.layer.bounds.width - self.freezeZone.left - self.freezeZone.right
        }
        
        self.maxContentWidths = Array.init(repeating: maxContentWidth, count: self.numberOfSteps)
        self.getAllTextSize(maxContentWidths: self.maxContentWidths)
        
        guard let shouldStepLineFitDescriptionText = self.delegate?.shouldStepLineFitDescriptionText(),shouldStepLineFitDescriptionText == true else {
            return self.layer.bounds.width - self.freezeZone.left - self.freezeZone.right
        }
        var totalWidth: CGFloat = 0
        let firstAnnularLayer = self.annularLayers.first
        let firstCircleRadius = circleRadius(firstAnnularLayer)
        let firstTitleOppositeViewWidth = self.titleOppositeViewSizes.first?.width ?? 0
        let firstTitleTextWidth = self.titleTextSizes.first?.width ?? 0
        let firstTitleIndentWidth = self.titleIndentSizes.first?.width ?? 0
        switch self.alignmentMode {
        case .top:
            totalWidth += [firstCircleRadius,firstTitleIndentWidth/2,firstTitleOppositeViewWidth/2].max() ?? 0
        case .center:
            totalWidth += [firstCircleRadius,firstTitleTextWidth/2].max() ?? 0
        }
        totalWidth -= firstCircleRadius
        
        for index in 0..<self.numberOfSteps - 1{
            let annularLayer = self.annularLayers[index]
            let lineLayer = self.lineLayers[index]
            switch self.alignmentMode {
            case .top:
                if self.titleTextSizes[index].width - self.titleIndentSizes[index].width / 2 - circleRadius(annularLayer) > lineLayer.config.processView?.frame.width ?? 0{//字没超出圆范围
                    totalWidth += circleDiameter(annularLayer)
                } else {
                    totalWidth += circleRadius(annularLayer) + self.titleTextSizes[index].width - self.titleIndentSizes[index].width / 2
                }
            case .center:
                totalWidth += max(self.titleTextSizes[index].width, circleDiameter(annularLayer))
            }
            totalWidth += minContentMargin
        }
        
        let lastAnnularLayer = self.annularLayers.last
        let lastCircleRadius = circleRadius(lastAnnularLayer)
        let lastTitleOppositeViewWidth = self.titleOppositeViewSizes.last?.width ?? 0
        let lastTitleTextWidth = self.titleTextSizes.last?.width ?? 0
        let lastTitleIndentWidth = self.titleIndentSizes.last?.width ?? 0
        switch self.alignmentMode {
        case .top:
            if let maxValue = [lastCircleRadius,lastTitleOppositeViewWidth/2,lastTitleTextWidth - lastTitleIndentWidth/2].max(),maxValue == lastTitleOppositeViewWidth/2 {
                totalWidth += maxValue
            }
        case .center:
            if let maxValue = [lastCircleRadius,lastTitleOppositeViewWidth/2,lastTitleTextWidth/2].max(),maxValue == lastTitleOppositeViewWidth/2 {
                totalWidth += maxValue
            }
        }
        
        return totalWidth
	}
	
    func getTotalContentHeight() -> CGFloat {
        guard let _ = self.dataSource else{
            return self.layer.bounds.height - self.freezeZone.top - self.freezeZone.bottom
        }
        self.maxContentWidths = self.getVerticalMaxContentWidths()
        self.getAllTextSize(maxContentWidths: maxContentWidths)
        guard let shouldStepLineFitDescriptionText = self.delegate?.shouldStepLineFitDescriptionText(),shouldStepLineFitDescriptionText == true else {
            return self.layer.bounds.height - self.freezeZone.top - self.freezeZone.bottom
        }
        
        var totalHeight: CGFloat = 0
        
        let firstAnnularLayer = self.annularLayers.first
        let firstCircleRadius = circleRadius(firstAnnularLayer)
        let firstTitleOppositeViewHeight = self.titleOppositeViewSizes.first?.height ?? 0
        let firstTitleTextHeight = self.titleTextSizes.first?.height ?? 0
        let firstTitleIndentHeight = self.titleIndentSizes.first?.height ?? 0
        switch self.alignmentMode {
        case .top:
            totalHeight += [firstCircleRadius,firstTitleIndentHeight/2,firstTitleOppositeViewHeight/2].max() ?? 0
        case .center:
            totalHeight += [firstCircleRadius,firstTitleTextHeight/2].max() ?? 0
        }
        totalHeight -= firstCircleRadius
        
        
        for index in 0..<self.numberOfSteps - 1 {
            let annularLayer = self.annularLayers[index]
            switch self.alignmentMode {
            case .top:
                if self.titleTextSizes[index].height - self.titleIndentSizes[index].height / 2 < circleRadius(annularLayer) {
                    totalHeight += circleDiameter(annularLayer)
                } else {
                    totalHeight += circleRadius(annularLayer) + self.titleTextSizes[index].height - self.titleIndentSizes[index].height / 2
                }
                    totalHeight += minContentMargin
            case .center:
                totalHeight += max(self.titleTextSizes[index].height, circleDiameter(annularLayer))
                    totalHeight += minContentMargin
            }
        }
        return totalHeight
    }
	
	fileprivate func getAllTextSize(maxContentWidths: [CGFloat]) {
		self.titleTextSizes.removeAll()
		self.titleIndentSizes.removeAll()
		for index in 0..<self.numberOfSteps {
			let size = self.getTextSize(index: index, maxContentWidth: maxContentWidths[index])
			self.titleTextSizes.append(size.textSize)
			self.titleIndentSizes.append(size.characterSize)
			self.descriptionTextLayers[index].titleSize = size.textSize
		}
	}
	
	fileprivate func getTextSize(index: Int, maxContentWidth: CGFloat = CGFloat.greatestFiniteMagnitude, maxContentHeight: CGFloat = CGFloat.greatestFiniteMagnitude) -> (textSize: CGSize, characterSize: CGSize) {
		guard let _dataSource = self.dataSource else {
			return (CGSize.zero, CGSize.zero)
		}
		
		let newTitle = _dataSource.titleForStep(indicator: self, index: index)
		let titleConfig = self.descriptionTextLayers[index].config
		
		let font = UIFont.systemFont(ofSize: titleConfig.title.fontSize)
		let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: titleConfig.title.style]
		let attributesText = NSAttributedString(string: newTitle, attributes: attributes as [NSAttributedString.Key: Any])
		let textSize = attributesText.boundingRect(with: CGSize.init(width: maxContentWidth, height: maxContentHeight), options: .usesLineFragmentOrigin, context: nil).size
		let characterAttributesText = NSAttributedString(string: String(newTitle.first ?? "K"), attributes: attributes as [NSAttributedString.Key: Any])
		let characterSize = characterAttributesText.boundingRect(with: CGSize.init(width: maxContentWidth, height: maxContentHeight), options: .usesLineFragmentOrigin, context: nil).size
		return (textSize, characterSize)
	}
	
	fileprivate func circleRadius(_ annularLayer: AnnularLayer?) -> CGFloat {
		annularLayer?.config.radius ?? self.circleRadius
	}
	
	fileprivate func circleDiameter(_ annularLayer: AnnularLayer?) -> CGFloat {
		self.circleRadius(annularLayer) * 2
	}
	
	private func getVerticalMaxContentWidths() -> [CGFloat] {
		let radius: [CGFloat] = self.annularLayers.map {
			circleDiameter($0)
		}
		let titleMargins: [CGFloat] = self.annularLayers.map {
			$0.config.titleMargin
		}
        let oppositeMargins : [CGFloat] = self.annularLayers.map { $0.config.viewMargin }
        let oppositeViewWidths : [CGFloat] = self.annularLayers.map{($0.config.oppositeView?.frame.width ?? 0)}
        ///圆环中心保持在一条线上
        let oppositeZip = zip(oppositeMargins, oppositeViewWidths).map(+)
        let maxCenterLeftWidth = zip(oppositeZip,radius).map(+).max() ?? 0
		let maxContentWidths: [CGFloat] = zip(radius, titleMargins)
			.map {
				$0 + $1 + maxCenterLeftWidth
			}
			.map {
				self.layer.frame.width - $0 - self.freezeZone.left - self.freezeZone.right
			}
		assert(maxContentWidths.min() ?? 0 > 0, "freeze参数或者oppoview尺寸过大,请重新设置")
		return maxContentWidths
	}
	
	private func layoutHorizontal() {
		var maxContentHeight: CGFloat = 0
		var contentHeights: [CGFloat] = []
		if let _ = self.dataSource {
			let titleMargins = self.annularLayers.map {
				$0.config.titleMargin
			}
			let titleHeights = self.titleTextSizes.map {
				$0.height
			}
			let radiuses = self.annularLayers.map {
				circleRadius($0)
			}
			let maxRadius = radiuses.max() ?? self.circleRadius
			let contentTop = radiuses.map {
				$0 + maxRadius
			}
			
			contentHeights = zip(zip(titleMargins, titleHeights).map(+), contentTop).map(+)
			maxContentHeight = contentHeights.max() ?? 0
		}
		let diameters: [CGFloat] = self.annularLayers.map {
			circleDiameter($0)
		}
		let maxDiameter = diameters.max() ?? self.circleRadius * 2
		var circleCenterY = (self.containerLayer.frame.height - self.freezeZone.top - self.freezeZone.bottom - maxContentHeight + maxDiameter) / 2 // Y起点
		
		var beyondHeights: [CGFloat] = Array.init(repeating: 0, count: self.numberOfSteps)
		let contentBeyondBound = (self.containerLayer.frame.height - self.freezeZone.top - self.freezeZone.bottom - maxContentHeight - maxDiameter) < 0
		if contentBeyondBound {
			circleCenterY = maxDiameter / 2 + self.freezeZone.top
			beyondHeights = contentHeights.map {
				self.containerLayer.frame.height - self.freezeZone.top - self.freezeZone.bottom - $0
			}.map {
				$0 > 0 ? 0 : abs($0)
			}
		}
		
		var processLengths: [CGFloat] = {
			guard self.numberOfSteps > 1 else {
				return Array.init(repeating: 0, count: self.numberOfSteps - 1)
			}
			
			var processLength: CGFloat = 0
			if let _dataSource = self.dataSource {
				if self.delegate?.shouldStepLineFitDescriptionText() ?? true {
					let textWidths = titleTextSizes.map {
						$0.width
					}
					var processLengths: [CGFloat] = []
					var comparedWidths = textWidths
					if self.alignmentMode == .top {
						for index in 0..<self.numberOfSteps - 1 {
							let annularLayer = self.annularLayers[index]
							let lineLayer = self.lineLayers[index]
							let circleRadiusMoreThanTitleTextSize = titleTextSizes[index].width - self.titleIndentSizes[index].width / 2 < circleRadius(annularLayer)
							if circleRadiusMoreThanTitleTextSize {
								processLength = minContentMargin - 2 * (lineLayer.config.marginBetweenCircle)
							} else {
								processLength = titleTextSizes[index].width + minContentMargin - 2 * (lineLayer.config.marginBetweenCircle)
								processLength += -titleIndentSizes[index].width / 2 - circleRadius(annularLayer)
							}
							processLengths.append(processLength)
						}
					} else {
						for index in 0..<self.numberOfSteps {
							let annularLayer = self.annularLayers[index]
							if comparedWidths[index] < circleDiameter(annularLayer) {
								comparedWidths[index] = 0
							} else {
								comparedWidths[index] -= circleDiameter(annularLayer)
							}
						}
						let widthPairs = zip(comparedWidths.prefix(upTo: comparedWidths.count - 1), comparedWidths.suffix(from: 1)).map {
							($0, $1)
						}
						for index in 0..<self.numberOfSteps - 1 {
							processLengths.append((widthPairs[index].0 + widthPairs[index].1) / 2 - (self.lineLayers[index].config.marginBetweenCircle) * 2 + minContentMargin)
						}
					}
					return processLengths
				} else {
					var totalLengthWithoutLine: CGFloat = 0
					for index in 0..<self.numberOfSteps {
						let annularLayer = self.annularLayers[index]
						totalLengthWithoutLine += circleDiameter(annularLayer)
						if index < self.numberOfSteps - 1 {
							let lineConfig = self.lineLayers[index].config
							totalLengthWithoutLine += (lineConfig.marginBetweenCircle) * 2
						}
					}
					switch self.alignmentMode {
					case .top:
						let lastAnnularLayer = self.annularLayers.last
						let circleRadiusMoreThanTitleTextSize = self.titleTextSizes.last!.width > circleDiameter(lastAnnularLayer) - self.titleTextSizes.last!.width / 2
						if circleRadiusMoreThanTitleTextSize {
							totalLengthWithoutLine += (self.titleTextSizes.last!.width) - circleDiameter(lastAnnularLayer)
							totalLengthWithoutLine += (titleIndentSizes.last!.width) / 2
						}
					case .center:
						let firstAnnularLayer = self.annularLayers.first
						let lastAnnularLayer = self.annularLayers.last
						if self.titleTextSizes.first!.width > circleDiameter(firstAnnularLayer) {
							totalLengthWithoutLine += (self.titleTextSizes.first!.width) / 2 - circleRadius(firstAnnularLayer)
						}
						if self.titleTextSizes.last!.width > circleDiameter(lastAnnularLayer) {
							totalLengthWithoutLine += (self.titleTextSizes.last!.width) / 2 - circleRadius(lastAnnularLayer)
						}
					}
					totalLengthWithoutLine += self.freezeZone.left + self.freezeZone.right
					processLength = (self.containerLayer.frame.width - totalLengthWithoutLine) / CGFloat(self.numberOfSteps - 1)
				}
			} else {//Storyboard
				processLength = (self.containerLayer.frame.width - self.lineMargin * 2 * CGFloat(self.numberOfSteps - 1) - 2 * self.circleRadius * CGFloat(self.numberOfSteps)) / CGFloat(self.numberOfSteps - 1)//每个步骤(一个圈加一整条线的宽度)
			}
			return Array.init(repeating: processLength, count: self.numberOfSteps - 1)
		}()
		
		func layoutHorizontalAnnularLayers(_index: Int) -> CGPoint {
			let annularStartX: CGFloat = {
				let firstAnnularLayer = self.annularLayers.first
				guard self.numberOfSteps > 1 else {
					return (self.containerLayer.frame.width - self.freezeZone.left - self.freezeZone.right) / 2.0 - circleRadius(firstAnnularLayer)
				}
				
				var currentLength: CGFloat = self.freezeZone.left
				if self.alignmentMode == .center {
					if circleDiameter(firstAnnularLayer) < self.titleTextSizes.first!.width {
						currentLength += (self.titleTextSizes.first!.width) / 2 - circleRadius(firstAnnularLayer)
					}
				}
				
				for __index in 0..<_index {
					let _annularLayer = self.annularLayers[__index]
					currentLength += circleDiameter(_annularLayer)
					currentLength += (self.lineLayers[__index].config.marginBetweenCircle) * 2
					currentLength += processLengths[__index]
				}
				return currentLength
			}()
			let annularLayer = self.annularLayers[_index]
			let annularStartY: CGFloat = circleCenterY - circleRadius(annularLayer)
			
			annularLayer.frame = CGRect(x: annularStartX, y: annularStartY, width: circleDiameter(annularLayer), height: circleDiameter(annularLayer))
			annularLayer.updateStatus()
			return CGPoint.init(x: annularStartX, y: annularStartY)
		}
		
		func layoutHorizontalLineLayer(_index: Int, annularPoint: CGPoint) {
			let annularLayer = self.annularLayers[_index]
			let lineLayer = self.lineLayers[_index]
			let lineStartX = annularPoint.x + circleDiameter(annularLayer) + (lineLayer.config.marginBetweenCircle)
			let lineStartY = annularPoint.y + circleRadius(annularLayer) - (lineLayer.config.strokeWidth) / 2
			lineLayer.frame = CGRect.init(x: lineStartX, y: lineStartY, width: processLengths[_index], height: lineLayer.config.strokeWidth)
			lineLayer.updateStatus()
		}
		
		func layoutHorizontalTitleLayer(_index: Int, annularPoint: CGPoint) {
			let descriptionTextLayer = self.descriptionTextLayers[_index]
			let annularLayer = self.annularLayers[_index]
			var descriptionStartX: CGFloat = annularPoint.x
			descriptionStartX += circleRadius(annularLayer)
			if self.alignmentMode == .center {
				descriptionStartX -= (self.titleTextSizes[_index].width) / 2
			} else {
				descriptionStartX -= self.titleIndentSizes[_index].width / 2
			}
			
			let descriptionStartY = annularPoint.y + circleDiameter(annularLayer) + (annularLayer.config.titleMargin)
			descriptionTextLayer.frame = CGRect.init(x: descriptionStartX, y: descriptionStartY, width: self.titleTextSizes[_index].width, height: self.titleTextSizes[_index].height - beyondHeights[_index])
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
		let circleCenterX: CGFloat = { //X中轴
			if let _ = self.dataSource {//靠左对齐
				let diameters: [CGFloat] = self.annularLayers.map {
					circleDiameter($0)
				}
				let maxDiameter = diameters.max() ?? self.circleRadius * 2
				return maxDiameter / 2 + freezeZone.left
			} else {
				return (self.containerLayer.frame.width - freezeZone.left - freezeZone.right) / 2.0
			}
		}()
		
		var processLengths: [CGFloat] = {
			guard self.numberOfSteps > 1 else {
				return Array.init(repeating: 0, count: self.numberOfSteps - 1)
			}
			var processLength: CGFloat = 0
			if let _dataSource = self.dataSource {
				
				if self.delegate?.shouldStepLineFitDescriptionText() ?? true {
					let textHeights = titleTextSizes.map {
						$0.height
					}
					var processLengths: [CGFloat] = []
					var comparedHeights = textHeights
					if self.alignmentMode == .top {
						for index in 0..<self.numberOfSteps - 1 {
							let annularLayer = self.annularLayers[index]
							let lineLayer = self.lineLayers[index]
							if titleTextSizes[index].height - self.titleIndentSizes[index].height / 2 < circleRadius(annularLayer) {
								processLength = minContentMargin - 2 * (lineLayer.config.marginBetweenCircle)
							} else {
								processLength = titleTextSizes[index].height + minContentMargin - 2 * (lineLayer.config.marginBetweenCircle)
								processLength += -titleIndentSizes[index].height / 2 - circleRadius(annularLayer)
							}
							processLengths.append(processLength)
						}
					} else {
						for index in 0..<self.numberOfSteps {
							let annularLayer = self.annularLayers[index]
							if comparedHeights[index] < circleDiameter(annularLayer) {
								comparedHeights[index] = 0
							} else {
								comparedHeights[index] -= circleDiameter(annularLayer)
							}
						}
						let heightPairs = zip(comparedHeights.prefix(upTo: comparedHeights.count - 1), comparedHeights.suffix(from: 1)).map {
							($0, $1)
						}
						for index in 0..<self.numberOfSteps - 1 {
							processLengths.append((heightPairs[index].0 + heightPairs[index].1) / 2 - (self.lineLayers[index].config.marginBetweenCircle) * 2 + minContentMargin)
						}
					}
					return processLengths
				} else {
					var totalLengthWithoutLine: CGFloat = 0
					for index in 0..<self.numberOfSteps {
						let annularLayer = self.annularLayers[index]
						
						totalLengthWithoutLine += circleDiameter(annularLayer)
						if index < self.numberOfSteps - 1 {
							let lineConfig = self.lineLayers[index].config
							totalLengthWithoutLine += (lineConfig.marginBetweenCircle) * 2
						}
					}
					if self.alignmentMode == .center {
						let firstAnnularLayer = self.annularLayers.first
						let lastAnnularLayer = self.annularLayers.last
						
						var topContentPadding: CGFloat = 0
						var bottomContentPadding: CGFloat = 0
						if self.titleTextSizes.first!.height > circleDiameter(firstAnnularLayer) {
							topContentPadding = (self.titleTextSizes.first!.height) / 2 - circleRadius(firstAnnularLayer)
						}
						if self.titleTextSizes.last!.height > circleDiameter(lastAnnularLayer) {
							bottomContentPadding = (self.titleTextSizes.last!.height) / 2 - circleRadius(lastAnnularLayer)
						}
						totalLengthWithoutLine += topContentPadding + bottomContentPadding
					} else if self.alignmentMode == .top {
						let lastAnnularLayer = self.annularLayers.last
						var bottomContentPadding: CGFloat = 0
						if self.titleTextSizes.last!.height > circleDiameter(lastAnnularLayer) {
							bottomContentPadding = (self.titleTextSizes.last!.height) / 2 - circleRadius(lastAnnularLayer)
							bottomContentPadding += (self.titleIndentSizes.last!.height) / 2
						}
					}
					totalLengthWithoutLine += self.freezeZone.top + self.freezeZone.bottom
					processLength = (self.containerLayer.frame.height - totalLengthWithoutLine) / CGFloat(self.numberOfSteps - 1)
				}
			} else {//Storyboard
				processLength = (self.containerLayer.frame.height - self.lineMargin * 2 * CGFloat(self.numberOfSteps - 1) - 2 * self.circleRadius * CGFloat(self.numberOfSteps) - self.freezeZone.top - self.freezeZone.bottom) / CGFloat(self.numberOfSteps - 1)//每个步骤(一个圈加一整条线的宽度)
			}
			return Array.init(repeating: processLength, count: self.numberOfSteps - 1)
		}()
		
		func layoutVerticalAnnularLayers(_index: Int) -> CGPoint {
			let annularLayer = self.annularLayers[_index]
			let annularStartY: CGFloat = {
				let firstAnnularLayer = self.annularLayers.first
				guard self.numberOfSteps > 1 else {
					return (self.containerLayer.frame.height - self.freezeZone.top - self.freezeZone.bottom) / 2.0 - circleRadius(firstAnnularLayer)
				}
				
				var currentLength: CGFloat = self.freezeZone.top
				if self.alignmentMode == .center {
					if circleDiameter(firstAnnularLayer) < self.titleTextSizes.first!.height {
						currentLength += (self.titleTextSizes.first!.height) / 2 - circleRadius(firstAnnularLayer)
					}
				}
				
				for __index in 0..<_index {
					currentLength += circleDiameter(self.annularLayers[__index])
					currentLength += (self.lineLayers[__index].config.marginBetweenCircle) * 2
					currentLength += processLengths[__index]
				}
				return currentLength
			}()
			let annularStartX: CGFloat = {
				if let _ = self.dataSource {
					return circleCenterX - circleRadius(self.annularLayers[_index])
				} else { // Storyboard
					return self.freezeZone.left
				}
			}()
			
			annularLayer.frame = CGRect(x: annularStartX, y: annularStartY, width: circleDiameter(annularLayer), height: circleDiameter(annularLayer))
			annularLayer.updateStatus()
			return CGPoint.init(x: annularStartX, y: annularStartY)
		}
		
		func layoutVerticalLineLayer(_index: Int, annularPoint: CGPoint) {
			let annularLayer = self.annularLayers[_index]
			let lineLayer = self.lineLayers[_index]
			let lineStartY = annularPoint.y + circleDiameter(annularLayer) + (lineLayer.config.marginBetweenCircle)
			let lineStartX = annularPoint.x + circleRadius(annularLayer) - (lineLayer.config.strokeWidth) / 2
			lineLayer.frame = CGRect.init(x: lineStartX, y: lineStartY, width: lineLayer.config.strokeWidth, height: processLengths[_index])
			lineLayer.updateStatus()
		}
		
		func layoutVerticalTitleLayer(_index: Int, annularPoint: CGPoint) {
			let descriptionTextLayer = self.descriptionTextLayers[_index]
			let annularLayer = self.annularLayers[_index]
			var descriptionStartY: CGFloat = annularPoint.y
			descriptionStartY += circleRadius(annularLayer)
			if self.alignmentMode == .center {
				descriptionStartY -= (self.titleTextSizes[_index].height) / 2
			} else {
				descriptionStartY -= self.titleIndentSizes[_index].height / 2
			}
			
			let descriptionStartX = annularPoint.x + circleDiameter(annularLayer) + (annularLayer.config.titleMargin)
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
	}
	
	private func applyDirection() {
		var rotation180: CATransform3D = CATransform3DIdentity
		if self.direction == .rightToLeft {
			rotation180 = CATransform3DMakeRotation(CGFloat.pi, 0.0, 1.0, 0.0)
		} else if self.direction == .bottomToTop {
			rotation180 = CATransform3DMakeRotation(CGFloat.pi, 1.0, 0.0, 0.0)
		}
		self.containerLayer.transform = rotation180
		self.annularLayers.forEach {
			$0.transform = rotation180
		}
		if self.dataSource != nil {
			self.descriptionTextLayers.forEach {
				$0.transform = rotation180
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
