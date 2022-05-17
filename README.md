# RealTimePicker

### RealTimePicker is an elegant and customizable time picker written in Swift.
<!-- 
<p align="center">
    <img src="https://github.com/toure20/RealTimePicker/blob/master/Screenshots/hour_min_screen.png" width="35%" height="35%" alt="Screenshot Preview" />
</p> -->

| 12-h format | 24-h format | Customizable | Example Usage |
| --- | --- | --- | --- |
| <img width=220px src="https://github.com/toure20/RealTimePicker/blob/master/Screenshots/example_screen_1.png" /> | <img width=220px src=https://github.com/toure20/RealTimePicker/blob/master/Screenshots/example_screen_2.png /> | <img width=220px src=https://github.com/toure20/RealTimePicker/blob/master/Screenshots/example_screen_3.png /> | <img width=220px src=https://github.com/toure20/RealTimePicker/blob/master/Screenshots/example_usage_1.png /> |

<p align="center">
    <img src="https://img.shields.io/badge/Platform-iOS_11+-green.svg" alt="Platform: iOS 11.0+" />
    <a href="https://developer.apple.com/swift" target="_blank"><img src="https://img.shields.io/badge/Language-Swift_4-blueviolet.svg" alt="Language: Swift 4+" /></a>
    <a href="https://cocoapods.org/pods/RealTimePicker" target="_blank"><img src="https://img.shields.io/badge/CocoaPods-v1.0-red.svg" alt="CocoaPods compatible" /></a>
    <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT" />
</p>

## Installation

* <a href="https://guides.cocoapods.org/using/using-cocoapods.html" target="_blank">CocoaPods</a>:

```ruby
pod 'RealTimePicker', '0.0.3'
```

## Usage

RealTimePickerView was designed over UIPickerView and can be used to pick time (hour, minute) with 24-h and 12-h format. Simply create `RealTimePickerView()` in the same way you would expect to present `UIPickerView` and use as a subview.

```swift
let view = RealTimePickerView(format: .h24, tintColor: .white)
view.timeLabelFont = UIFont.systemFont(ofSize: 44, weight: .semibold) // default size is 44
view.colonLabelFont = UIFont.systemFont(ofSize: 44 * 0.75, weight: .bold) // default size
view.formatLabelFont = UIFont.systemFont(ofSize: 24, weight: .semibold) // default size is 24
view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
view.showCurrentTime = true
view.layer.cornerRadius = 24
```
Use `updateDateTime(_ date: Date)` function in order to set default time to picker view.

### Sample App

Check out the [Sample App](https://github.com/toure20/RealTimePicker/tree/master/RealTimePickerExamples) for more complex configurations of `RealTimePickerView`, including how to change hour format, time components and apply layout constaints.

## License

<b>RealTimePicker</b> is released under a MIT License. See LICENSE file for details. Requires **iOS 11+** and is compatible with **Swift 4+** projects.
