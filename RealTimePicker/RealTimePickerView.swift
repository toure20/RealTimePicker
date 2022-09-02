//
//  RealTimePickerView.swift
//  RealTimePicker
//
//  Created by Toremurat Zholayev on 21.04.2022.
//  Copyright © 2022 AlashDevs. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

open class RealTimePickerView: UIView {
    private enum Constants {
        static let fontSize: CGFloat = 44
        static let colonFontSize: CGFloat = Constants.fontSize * 0.75
        static let formatFontSize: CGFloat = 24
    }
    
    public enum TimeFormat: String {
        case h12
        case h24
        
        var hours: [Int] {
            switch self {
            case .h12:
                return Array(1...12)
            case .h24:
                return Array(0...23)
            }
        }
        
        var components: [TimeComponent] {
            switch self {
            case .h12:
                return [.hour, .minute, .format]
            case .h24:
                return [.hour, .minute]
            }
        }
    }
    
    public enum HourFormat: String, CaseIterable {
        case am = "AM"
        case pm = "PM"
    }
    
    public enum TimeComponent: Int, CaseIterable {
        case hour = 0
        case minute = 1
        case format = 2
    }
    
    // MARK: - Public properties
    
    /// The default value in picker view with current time
    public var showCurrentTime: Bool = false {
        didSet {
            if showCurrentTime {
                updateDateTime(Date())
            }
        }
    }
    /// The default height in points of each row in the picker view.
    public var rowHeight: CGFloat = 60.0
    /// The default label font of each time row component in the picker view.
    public var timeLabelFont: UIFont?
    /// The default label font of format (AM/PM) component in the picker view.
    public var formatLabelFont: UIFont?
    /// The default font of colon between picker components
    public var colonLabelFont: UIFont? {
        didSet {
            colonLabel.font = colonLabelFont
        }
    }
    // The default static ":" indicator between columns.
    public var showUnitSeparator = true {
        didSet {
            colonLabel.isHidden = !showUnitSeparator
        }
    }
    
    /// Callback for pickerView(didSelectRow:) method in Date format
    public var onDateTimePicked: ((Date) -> Void)?
    /// Callback for pickerView(didSelectRow:) method in (hour: Int, minute: Int) format
    public var onNumberTimePicked: ((_ hour: Int, _ minute: Int) -> Void)?
    
    // MARK: - Private properties
    
    private var timeFormat: TimeFormat
    private var components: [TimeComponent]
    private var hours: [Int]
    private var minutes: [Int] = Array(0..<60)
    private var hourFormats: [HourFormat] = HourFormat.allCases
    
    private var selectedHour: Int?
    private var selectedMinute: Int?
    private var selectedHourFormat: HourFormat?
    
    private var hourRows: Int = 10_000
    private lazy var hourRowsMiddle: Int = ((hourRows / hours.count) / 2) * hours.count
    private var minuteRows: Int = 10_000
    private lazy var minuteRowsMiddle: Int = ((minuteRows / minutes.count) / 2) * minutes.count
    
    // MARK: - Views
    
    public var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private lazy var colonLabel: UILabel = {
        let label = UILabel()
        let size = Constants.colonFontSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        label.textColor = tintColor
        label.text = ":"
        return label
    }()
    
    private var leftConstraintAnchor: NSLayoutConstraint?
    
    public init(format: TimeFormat = .h24, tintColor: UIColor = .black) {
        self.timeFormat = format
        self.components = format.components
        self.hours = format.hours
        super.init(frame: .zero)
        self.tintColor = tintColor
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        nil
    }
    
    public func update(timeFormat: TimeFormat) {
        self.timeFormat = timeFormat
        self.components = timeFormat.components
        self.hours = timeFormat.hours
        pickerView.reloadAllComponents()
        layoutSubviews()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard !components.isEmpty else { return }
        let offset = (frame.width / CGFloat(components.count)) - 2
        leftConstraintAnchor?.constant = offset
        leftConstraintAnchor?.isActive = true
    }
    
    open func setupViews() {
        addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pickerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        pickerView.addSubview(colonLabel)
        colonLabel.translatesAutoresizingMaskIntoConstraints = false
        colonLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        leftConstraintAnchor = colonLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    open func setInitialValue() {
        selectedMinute = 0
        self.pickerView.selectRow(minuteRowsMiddle, inComponent: TimeComponent.minute.rawValue, animated: false)
        
        selectedHour = 0
        self.pickerView.selectRow(hourRowsMiddle, inComponent: TimeComponent.hour.rawValue, animated: false)
    }
    
    open func updateDateTime(_ date: Date) {
        let currentTime = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        if var hour = currentTime.hour, components.count > TimeComponent.hour.rawValue {
            if timeFormat == .h12 {
                selectedHourFormat = hour < 12 ? .am : .pm
                /// 0:00 / midnight to 0:59 add 12 hours and AM to the time:
                if hour == 0 {
                    selectedHourFormat = .am
                    hour += 12
                }
                /// From 1:00 to 11:59, simply add AM to the time:
                if hour >= 1 && hour <= 11 {
                    selectedHourFormat = .am
                }
                /// For times between 13:00 to 23:59, subtract 12 hours and add PM to the time:
                if hour >= 13 && hour <= 23 {
                    hour -= 12
                    selectedHourFormat = .pm
                }
            }
            let neededRowIndex = hourRowsMiddle + hour
            self.selectedHour = hour
            switch selectedHourFormat {
            case .am:
                pickerView.selectRow(0, inComponent: TimeComponent.format.rawValue, animated: true)
            case .pm:
                pickerView.selectRow(1, inComponent: TimeComponent.format.rawValue, animated: true)
            default:
                break
            }
            switch timeFormat {
            case .h12 where hours.first == 1:
                pickerView.selectRow(neededRowIndex - 1, inComponent: TimeComponent.hour.rawValue, animated: true)
            case .h24:
                pickerView.selectRow(neededRowIndex, inComponent: TimeComponent.hour.rawValue, animated: true)
            default:
                break
            }
        }
        
        if let minute = currentTime.minute, components.count > TimeComponent.minute.rawValue {
            let neededRowIndex = minuteRowsMiddle + minute
            self.selectedMinute = minute
            pickerView.selectRow(neededRowIndex, inComponent: TimeComponent.minute.rawValue, animated: true)
        }
    }
}

extension RealTimePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return components.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch components[component] {
        case .hour:
            return hourRows
        case .minute:
            return minuteRows
        case .format:
            return hourFormats.count
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = tintColor
        label.font = timeLabelFont ?? UIFont.systemFont(ofSize: Constants.fontSize, weight: .semibold)
        switch components[component]  {
        case .hour:
            label.text = String(format: "%02d", hours[row % hours.count])
        case .minute:
            label.text = String(format: "%02d", minutes[row % minutes.count])
        case .format:
            label.font = formatLabelFont ?? UIFont.systemFont(ofSize: Constants.formatFontSize, weight: .bold)
            label.text = hourFormats[row].rawValue
        }
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch components[component] {
        case .hour:
            self.selectedHour = hours[safe: row % hours.count]
        case .minute:
            self.selectedMinute = minutes[safe: row % minutes.count]
        case .format:
            self.selectedHourFormat = hourFormats[safe: row]
        }
        guard var hour = selectedHour, let minute = selectedMinute else { return }
        var calendar = Calendar.current
        calendar.timeZone = .current
        switch selectedHourFormat {
        case .pm where hour >= 1 && hour <= 11:
            hour += 12
        case .am where hour == 12:
            hour -= 12
        default:
            break
        }
        guard let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of:  Date()) else {
            return
        }
        onDateTimePicked?(date)
        onNumberTimePicked?(hour, minute)
    }
}
