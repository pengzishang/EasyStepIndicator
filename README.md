# EasyStepIndicator

More attributes for a step indicator, indicates steps with a easy way

<img src="https://s2.ax1x.com/2019/10/23/KYvrFJ.gif" alt="KYvrFJ.gif" border="0" />

## Background

因为自身项目需要,
参考了https://github.com/chenyun122/StepIndicator 
做出了一些改良,这个步骤指示器能提供更多的属性,比如虚线线条,虚线边框,指示器内文字,步骤描述文字

## Install

将EasyStepIndicator拖入工程文件夹,在Storyboard中相应的View

<img src="https://s2.ax1x.com/2019/10/23/KYvweU.png" alt="KYvweU.png" border="0" />

## Usage
### 基本使用
#### 如果你使用Storyboard

> ```swift
> IBOutlet weak var indicator: EasyStepIndicator!
> ```
如果你要设置圈内文字和描述文字
打开
> ```swift
> showStepDescriptionTexts
> showCircleText
> ```

> ```swift
> indicator.stepCircleTexts = ["A","B","C","D"]
> indicator.stepDescriptionTexts = \["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation", "Site\nsecured"]
> ```


#### 如果你用代码
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



## TODO
欢迎大家提意见和建议

- [ ] 上传到Cocoapods;
- [ ] 描述文字适配垂直方向;
- [ ] 垂直方向Demo



[image-1]:	/Demo/1.gif
[image-2]:	/Demo/Xnip2019-10-17_12-17-21.png
[image-3]:      /Demo/2.png




