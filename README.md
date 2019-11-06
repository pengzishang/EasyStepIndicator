# EasyStepIndicator

[English](https://github.com/pengzishang/EasyStepIndicator/blob/master/README_EN.md)

<h3 align="left"><a href="https://github.com/pengzishang/EasyStepIndicator" target="_blank">Github</a></h3>
欢迎大家给意见,给Star

给步骤指示器加入更多的属性,更多可定制的样式

### 横向模式

<img src="https://s2.ax1x.com/2019/11/06/MiCEE6.gif" alt="MiCEE6.gif" border="0" />

### 纵向正向

<img src="https://s2.ax1x.com/2019/11/06/MiCsaV.gif" alt="MiCsaV.gif" border="0" />

### 纵向逆向

<img src="https://s2.ax1x.com/2019/11/06/MiPiRg.gif" alt="MiPiRg.gif" border="0" />

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

```swift
@IBOutlet weak var indicator: EasyStepIndicator!
```

#### 如果你要设置步骤进度的方向

![K6nd0J.png](https://s2.ax1x.com/2019/10/28/K6nd0J.png)

| Raw值 | 意义 | 描述  |
|:--------------------:|:---------------------------:|:---------------------------:|
|0|leftToRight|从左到右|
|1|rightToLeft|从右到左|
|2|topToBottom|从顶到底|
|3|bottomToTop|从底到顶|

#### 如果要在Storyboard完成所有的工作
图中属性在下面有介绍

<img src="https://s2.ax1x.com/2019/11/06/MiFJ56.png" alt="MiFJ56.png" border="0" />


### 如果你用代码
```swift
    self.indicator = EasyStepIndicator.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.width, height: self.view.bounds.width/2)))
    self.indicator?.center = self.view.center
    indicator?.numberOfSteps = 4 // 必须第一时间赋予
    self.view.addSubview(indicator!)
```
## 公共部分
### 如果你要设置圈内文字和描述文字
>self.indicator.dataSource = self

```swift
extension VerticalController:EasyStepIndicatorDataSource {
    func characterForStep(indicator: EasyStepIndicator, index: Int) -> String {
        ["1","B","2","D"][index]
    }
    
    func titleForStep(indicator: EasyStepIndicator, index: Int) -> String {
        ["Yours faithfully", " This is to introduce Mr. Frank Jones, our new marketing specialist who will be in London from April 5 to mid April on business. We are pleased to introduce Mr. Wang You, our import manager of Textiles Department. Mr. Wang is spending three weeks in your city to develop our business with chief manufactures and to make purchases of decorative fabrics for the coming season.", "Track progress", "Finishes\ninvestigation"][index]
    }
}
 ```

### 如果你要单独设置每个圈
>self.indicator.delegate = self
```swift
extension VerticalController :EasyStepIndicatorDelegate {

     func stepConfigForStep(indicator: EasyStepIndicator, index: Int, config: inout StepConfig){
         if index == 2{
             config.radius = 30
         }
         if index == 3 {
             config.stepText.fontSize = 30
         }
         config.stepText.colors.complete = randomColor()
         config.stepText.colors.incomplete = randomColor()
         config.annular.colors.complete = randomColor()
         config.annular.colors.incomplete = randomColor()
         config.tint.colors.complete = randomColor()
         config.tint.colors.incomplete = randomColor()
     }
     
     func lineConfigForProcess(indicator: EasyStepIndicator, index: Int, config:inout LineConfig){
         config.colors.complete = randomColor()
         config.colors.incomplete = randomColor()
     }
     
     func titleConfigForStep(indicator: EasyStepIndicator, index: Int, config:inout TitleConfig){
         config.colors.complete = randomColor()
         config.colors.incomplete = randomColor()
     }
 }
```

你可以对每一个元素的每个属性做出自己的定制 


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
| circleTextIncompleteColor| 圆形内文字未完成时候颜色|C的颜色|
| circleTextCompleteColor| 圆形内文字完成时候颜色|A的颜色|
| stepDescriptionTextMargin| Indicator和Description之间Margin|12|
| stepDescriptionTextFontSize| 步骤描述文字的大小|13|


## TODO
欢迎大家提意见和建议

- [x] 上传到Cocoapods;
- [x] 描述文字适配垂直方向;
- [x] 垂直方向Demo
- [x] 代码描述
- [ ] 将超出部分显示为...
- [ ] 自适应超出部分设置为滚动
- [ ] 自定义描述部分的View,不限于文字
