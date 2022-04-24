# RealTimePicker

### RealTimePicker is an elegant and customizable time (hour, minute, second) picker written in Swift.

<p align="center">
    <img src="https://github.com/toure20/RealTimePicker/blob/master/Screenshots/hour_min_screen.png" width="30%" height="30%" alt="Screenshot Preview" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Platform-iOS_12+-green.svg" alt="Platform: iOS 12.0+" />
    <a href="https://developer.apple.com/swift" target="_blank"><img src="https://img.shields.io/badge/Language-Swift_5-blueviolet.svg" alt="Language: Swift 5" /></a>
    <a href="https://cocoapods.org/pods/RealTimePicker" target="_blank"><img src="https://img.shields.io/badge/CocoaPods-v1.0-red.svg" alt="CocoaPods compatible" /></a>
    <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT" />
</p>


RealTimePicker requires **iOS 12+** and is compatible with **Swift 5** projects.

## Installation

* <a href="https://guides.cocoapods.org/using/using-cocoapods.html" target="_blank">CocoaPods</a>:

```ruby
pod 'RealTimePicker'
```

## Usage

RealTimePickerView was designed over UIPickerView and can be customize by your own needs. Simply create `RealTimePickerView()` in the same way you would expect to present `UIPickerView` and user as a subview.

```swift
let view = RealTimePickerView()
view.rowHeight = 80 // default row height
view.colonLabelFont = UIFont.systemFont(ofSize: 40, weight: .bold)
view.timeLabelFont = UIFont.systemFont(ofSize: 54, weight: .semibold
```

### Sample App

Check out the [Sample App](https://github.com/toure20/RealTimePicker/tree/master/RealTimePickerExamples) for more complex configurations of `RealTimePickerView`, including how to change hour format, time components and apply layout constaints.

## License

<b>RealTimePicker</b> is released under a MIT License. See LICENSE file for details.
