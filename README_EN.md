# EasyStepIndicator

<h3 align="left"><a href="https://github.com/pengzishang/EasyStepIndicator" target="_blank">Github</a></h3>
Welcome everyone to give advice ,giveStar

Add more attributes to the step indicator, more customizable styles

Landscape mode

<img src="https://s2.ax1x.com/2019/10/23/KYvrFJ.gif" alt="KYvrFJ.gif" border="0" />

Vertical inverted text adaptation mode

<img src="https://s2.ax1x.com/2019/10/25/KwFHLF.gif" alt="KwFHLF.gif" border="0" />

Longitudinal forward length equal mode

<img src="https://s2.ax1x.com/2019/10/25/KwAV74.gif" alt="KwAV74.gif" border="0" />

## Background

Because of their own project needs,
fork the project https://github.com/chenyun122/StepIndicator 
Made some improvements,This step indicator provides more properties, such as dashed lines, dashed borders, in-character text, step description text
Will continue to do more styles in the future

## Installation method

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

If you want to set the direction of the step progress

![K6nd0J.png](https://s2.ax1x.com/2019/10/28/K6nd0J.png)
| Raw value | Meaning | Description |
|:--------------------:|:------------------------- --:|:---------------------------:|
|0|leftToRight|From left to right |
|1|rightToLeft|From right to left|
|2|topToBottom|From top to bottom|
|3|bottomToTop|From bottom to top|


### Code
```swift
let indicator = EasyStepIndicator.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width:300, height: 300)))
self.view.addSubview(indicator)
indicator.numberOfSteps = 4//If you need to adjust the steps
indicator.currentStep = 2 //If you need to adjust the current progress
indicator.circleRadius = 15 //Circle size
indicator.showCircleText = true
indicator.stepCircleTexts = ["A","B","C","D"]//Text inside the box
indicator.showStepDescriptionTexts = true
indicator.stepDescriptionTexts = ["Alarm\ntriggered", "Dispatch\na guard", "Track\nprogress", "Finishes\ninvestigation", "Site\nsecured"]//Descriptive text under the circle
indicator.direction = .leftToRight //direction
//If you use portrait mode
indicator.stepLineFitDescriptionText = true //Connect line length to fit text
```


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
| directionRaw|Int value of progress direction, select direction with Storyboard|None|
| showInitialStep| Whether to display the starting circle|⑦|
| showCircleText| Whether to display the text in the circle|ABCD|
| stepCircleTexts| Descriptive text inside the circle, it is recommended to enter only one number||
| circleTextIncompleteColor| Color inside the circle when the text is not completed| C's color|
| circleTextCompleteColor| Color inside the circle when the text is finished |A's color|
| showStepDescriptionTexts| Whether to display step description text | below 13|
| stepDescriptionTexts| Step Description Text |13|
| stepDescriptionTextMargin| Margin between Indicator and Description|12|
| stepDescriptionTextFontSize| Step Description Text Size |13|
| stepLineFitDescriptionText | Line adapts to the height of the text. If there is too much text, it is recommended to open (more text will overflow superview). If it is closed, the height of Line is associated with SuperView, it will not overflow superview |无|


## TODO
Welcome everyone to provide comments and suggestions

- [x] uploaded to Cocoapods;
- [x] describes the text adaptation to the vertical direction;
- [x] Vertical Direction Demo
- [ ] Code Description
- [ ] Custom description section of View,Welcome everyone to provide comments and suggestions

