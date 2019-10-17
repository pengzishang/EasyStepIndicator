# EasyStepIndicator

More attributes for a step indicator, indicates steps with a easy way

![img][image-1]

## Table of Contents

- [Background]()(#background)
- [Install]()(#install)
- [Usage]()(#usage)
	- [Generator]()(#generator)
- [Badge]()(#badge)
- [Example Readmes]()(#example-readmes)
- [Related Efforts]()(#related-efforts)
- [Maintainers]()(#maintainers)
- [Contributing]()(#contributing)
- [License]()(#license)


## Background

因为自身项目需要,
参考了https://github.com/chenyun122/StepIndicator 
做出了一些改良,这个步骤指示器能提供更多的属性,比如虚线线条,虚线边框,指示器内文字,步骤描述文字

## Install

将EasyStepIndicator拖入工程文件夹,在Storyboard中相应的View

![][image-2]

## Usage
### 基本使用
#### 如果你使用Storyboard
那么没有特别的步骤

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

就OK了

#### 如果你用代码










[image-1]:	/Demo/1.gif
[image-2]:	/Demo/Xnip2019-10-17_12-17-21.png