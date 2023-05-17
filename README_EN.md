# EasyStepIndicator
[中文](https://github.com/pengzishang/EasyStepIndicator/blob/master/README.md)｜English

<h3 align="left"><a href="https://github.com/pengzishang/EasyStepIndicator" target="_blank">Github</a></h3>
Welcome everyone to give advice ,giveStar

Add more attributes to the step indicator, more customizable styles

<img src="https://s2.ax1x.com/2019/11/12/M3dU3t.gif" alt="M3dU3t.gif" border="0" />

## Background

Because of their own project needs,
fork the project https://github.com/chenyun122/StepIndicator 
Made some improvements,This step indicator provides more properties, such as dashed lines, dashed borders, in-character text, step description text
Will continue to do more styles in the future

## Install

> pod 'EasyStepIndicator'

## Usage
### Storyboard

<img src="https://s2.ax1x.com/2019/10/23/KYvweU.png" alt="KYvweU.png" border="0" />

> ```swift
> IBOutlet weak var indicator: EasyStepIndicator!
> ```
If you want to set the inline text and description text
Open the options in the Storyboard
 
![K6mjW6.jpg](https://s2.ax1x.com/2019/10/28/K6mjW6.jpg)

Then set the text

> ```swift
> indicator.stepCircleTexts = ["A","B","C","D"]
> indicator.stepDescriptionTexts = \["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation", "Site\nsecured"]
> ```

#### If you want to set the direction of the step progress

![K6nd0J.png](https://s2.ax1x.com/2019/10/28/K6nd0J.png)

| Raw value | Meaning | Description |
|:--------------------:|:---------------------------:|:---------------------------:|
|0|leftToRight|From left to right |
|1|rightToLeft|From right to left|
|2|topToBottom|From top to bottom|
|3|bottomToTop|From bottom to top|

#### If you want to do all the work on the Storyboard
The properties in the figure are described below.

<img src="https://s2.ax1x.com/2019/11/06/MiFJ56.png" alt="MiFJ56.png" border="0" />


### Code
```swift
    self.indicator = EasyStepIndicator.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.width, height: self.view.bounds.width/2)))
    self.indicator?.center = self.view.center
    indicator?.numberOfSteps = 4 // must be given the first time
    self.view.addSubview(indicator!)
```

### Storyboard and the public part of the code
#### If you want to set the circle internal text and description text
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

#### If you want to set each circle separately
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

You can make your own customizations for each attribute of each element.

## Attributes

<img src="https://s2.ax1x.com/2019/10/23/KYvUyV.png" alt="KYvUyV.png" border="0" />

| Property Name | Description | Location |
|:--------------------:|:---------------------------:|:----------------------------:|
| numberOfSteps | Total number of steps ||
| currentStep | Current Step |①|
| currentStepAsIncomplete| The current step is considered incomplete|①|
| circleRadius| circle size|③|
| circleAnnularIncompleteColor | Indicates the color when the round frame is not completed|④|
| circleAnnularCompleteColor| indicates the color when the round frame is completed|②|
| circleStrokeWidth| indicates the width of the circle line|③|
| circleAnnularLineDashWidth| indicates the length of the dotted circle|④|
| circleAnnularLineDashMargin|  indicates round frame dashed interval |④|
| circleTintIncompleteColor| The color of the circle when the circle is not completed|④corresponds to the circle|
| circleTintCompleteColor| The color at the completion of the circle |②|
| lineIncompleteColor| points to the unfinished color of the line|⑥|
| lineCompleteColor| points to the color of the line completion| the color between A-B|
| lineMargin| points to the distance of the line from the circle|⑤|
| lineStrokeWidth| points to line width |⑥|
| lineImaginaryMargin| points to the dotted line spacing |⑥|
| lineImaginaryWidth| points to the line with a small dashed width |⑥|
| direction|Progress direction, you can set when writing code, select value in the enumeration value |a-b-c-d|
| circleTextIncompleteColor| Color inside the circle when the text is not completed| C's color|
| circleTextCompleteColor| Color inside the circle when the text is finished |A's color|
| stepDescriptionTextIncompleteColor|Describe the color when the text is not completed|11|
| stepDescriptionTextCompleteColor|Describe the color when the text is completed|13|
| stepDescriptionTextMargin| Margin between Indicator and Description|12|
| stepDescriptionTextFontSize| Step Description Text Size |13|
| stepLineFitDescriptionText | Line adapts to the height of the text. If there is too much text, it is recommended to open (more text will overflow superview). If it is closed, the height of Line is associated with SuperView, it will not overflow superview |无|
| maxContentWidth| Maximum content width (only available horizontally)||
| minContentMargin| Descriptive text forced minimum spacing||
| contentScrollView| Content scroll view||
|freezeZone|Freeze area, area will have no content, leave blank||



### Codeable Attributes

| Class | Attribute | Description |
|:--------------------:|:---------------------------:|:----------------------------:|
|StepConfig|stepText|Circle related attributes|
|StepConfig|annular|annular related properties|
|StepConfig|tint| Related properties in circles |
|StepConfig|radius|Circle Radius|
|StepConfig|stepIndex|Step No.|
|StepConfig|titleMargin|Describe the distance between the text and the bottom of the circle|
|-|-|-|
|LineConfig|colors|Line color related properties|
|LineConfig|dashPatternComplete|The dotted line related properties of the completed line|
|LineConfig|dashPatternIncomplete|Dash line related properties of unfinished lines|
|LineConfig|strokeWidth|Line Width|
|LineConfig|marginBetweenCircle|The distance from the line to the circle|
|LineConfig|processIndex|Line index|
|-|-|-|
|TitleConfig|title|Describe title related attributes|
|TitleConfig|colors|Describe title color related properties|
|TitleConfig|stepIndex|Description title index|

### About alignmentMode
>public var alignmentMode: AlignmentMode = .center

| Value | Description |
|:---------------------------:|:---------------------------:|
|top|The starting alignment of each title and circle|
|center|Each title and start are aligned with the center of the circle, |

<img src="https://s2.ax1x.com/2019/11/07/MiXIu6.gif" alt="MiXIu6.gif" border="0" />

### About shouldStepLineFitDescriptionText
```swift
    func shouldStepLineFitDescriptionText() -> Bool {
        false
    }
```

>true: the length of the entire indicator varies with the amount of description
>
>false: the length of the entire indicator is fixed to the length of the superview

<img src="https://s2.ax1x.com/2019/11/07/MiXvvt.gif" alt="MiXvvt.gif" border="0" />

## TODO
Welcome everyone to provide comments and suggestions

- [x] uploaded to Cocoapods;
- [x] describes the text adaptation to the vertical direction;
- [x] Demo
- [x] code description
- [x] displays the excess as "..."
- [x] Adaptive excess is set to scroll
- [ ] View of the custom description section, not limited to text
