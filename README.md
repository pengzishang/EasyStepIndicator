# EasyStepIndicator

[English](https://github.com/pengzishang/EasyStepIndicator/blob/master/README_EN.md)

<h3 align="left"><a href="https://github.com/pengzishang/EasyStepIndicator" target="_blank">Github</a></h3>
欢迎大家给意见,给Star

给步骤指示器加入更多的属性,更多可定制的样式

横向模式

<img src="https://s2.ax1x.com/2019/10/23/KYvrFJ.gif" alt="KYvrFJ.gif" border="0" />

纵向倒置文字适配模式

<img src="https://s2.ax1x.com/2019/10/25/KwFHLF.gif" alt="KwFHLF.gif" border="0" />

纵向正向长度相等模式

<img src="https://s2.ax1x.com/2019/10/25/KwAV74.gif" alt="KwAV74.gif" border="0" />

## 背景

因为自身项目需要,
fork了https://github.com/chenyun122/StepIndicator 
做出了一些改良,这个步骤指示器能提供更多的属性,比如虚线线条,虚线边框,指示器内文字,步骤描述文字
将来会继续做更多的样式

## 安装方法

> pod 'EasyStepIndicator'

## 使用
### 如果你使用Storyboard

<img src="https://s2.ax1x.com/2019/10/23/KYvweU.png" alt="KYvweU.png" border="0" />

> ```swift
> IBOutlet weak var indicator: EasyStepIndicator!
> ```
 如果你要设置圈内文字和描述文字
 打开在Storyboard中的选项

![K6mjW6.jpg](https://s2.ax1x.com/2019/10/28/K6mjW6.jpg)

然后设置相应文字

> ```swift
> indicator.stepCircleTexts = ["A","B","C","D"]
> indicator.stepDescriptionTexts = \["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation", "Site\nsecured"]
> ```

如果你要设置步骤进度的方向

![K6nd0J.png](https://s2.ax1x.com/2019/10/28/K6nd0J.png)
| Raw值 | 意义 | 描述  |
|:--------------------:|:---------------------------:|:---------------------------:|
|0|leftToRight|从左到右|
|1|rightToLeft|从右到左|
|2|topToBottom|从顶到底|
|3|bottomToTop|从底到顶|


### 如果你用代码
```swift
let indicator = EasyStepIndicator.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width:300, height: 300)))
self.view.addSubview(indicator)
indicator.numberOfSteps = 4//如果需要调整步骤
indicator.currentStep = 2 //如果需要调整目前进度
indicator.circleRadius = 15 //圆圈大小
indicator.showCircleText = true
indicator.stepCircleTexts = ["A","B","C","D"]//框内的文字
indicator.showStepDescriptionTexts = true
indicator.stepDescriptionTexts = ["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation", "Site\nsecured"]//圆下的描述文字
indicator.direction = .leftToRight //方向
//如果你使用纵向模式
indicator.stepLineFitDescriptionText = true //连接线条长度适应文本
```


## 属性列表

<img src="https://s2.ax1x.com/2019/10/23/KYvUyV.png" alt="KYvUyV.png" border="0" />

| 属性名 | 描述  | 图中位置 |
|:--------------------:|:---------------------------:|:----------------------------:|
| numberOfSteps | 总步骤数量 ||
| currentStep | 当前步骤 |①|
| currentStepAsIncomplete| 当前步骤视为未完成|①|
| circleRadius| 圆大小|③|
| circleAnnularIncompleteColor | 指示圆框未完成时候的颜色|④|
| circleAnnularCompleteColor| 指示圆框完成时候的颜色|②|
| circleStrokeWidth| 指示圆框线条的宽度|③|
| circleAnnularLineDashWidth| 指示圆框虚线长度|④|
| circleAnnularLineDashMargin| 指示圆框虚线间隔|④|
| circleTintIncompleteColor| 圆内未完成时候的颜色|④对应的圆|
| circleTintCompleteColor| 圆内完成时候的颜色|②|
| lineIncompleteColor| 指向线条未完成的颜色|⑥|
| lineCompleteColor| 指向线条完成的颜色|A-B之间的颜色|
| lineMargin| 指向线条离圆形的距离|⑤|
| lineStrokeWidth| 指向线条宽度|⑥|
| lineImaginaryMargin| 指向线条虚线间隔|⑥|
| lineImaginaryWidth| 指向线条小虚线宽度|⑥|
| direction|进度方向,写代码时候可以设置,在枚举值中选择|a-b-c-d|
| directionRaw|进度方向的Int值,用Storyboard中选择方向|无|
| showInitialStep| 是否显示起始圆框|⑦|
| showCircleText| 是否显示框内文字|ABCD|
| stepCircleTexts| 圆形内描述文字,建议只输入一个数字|ABCD或者1234任何不超过一位的字符|
| circleTextIncompleteColor| 圆形内文字未完成时候颜色|C的颜色|
| circleTextCompleteColor| 圆形内文字完成时候颜色|A的颜色|
| showStepDescriptionTexts| 是否显示步骤描述文字|下方13处|
| stepDescriptionTexts| 步骤描述文字|13处|
| stepDescriptionTextMargin| Indicator和Description之间Margin|12|
| stepDescriptionTextFontSize| 步骤描述文字的大小|13|
| stepLineFitDescriptionText | Line是否适应文字的高度,如果文字过多,建议开启(文字多会溢出superview),如果关闭的,Line的高度是与SuperView关联,不会溢出superview |无|


## TODO
欢迎大家提意见和建议

- [x] 上传到Cocoapods;
- [x] 描述文字适配垂直方向;
- [x] 垂直方向Demo
- [ ] 代码描述
- [ ] 自定义描述部分的View,不限于文字
