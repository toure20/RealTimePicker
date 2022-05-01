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
                return Array(0...24)
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
    
    /// Callback for pickerView(didSelectRow:) method in Date format
    public var onDateTimePicked: ((Date) -> Void)?
    /// Callback for pickerView(didSelectRow:) method in (hour: Int, minute: Int) format
    public var onNumberTimePicked: ((_ hour: Int, _ minute: Int) -> Void)?
    
    // MARK: - Private properties
    private var timeFormat: TimeFormat
    private var components: [TimeComponent]
    private var hours: [Int]
    private var minutes: [Int] = Array(0...60)
    private var hourFormats: [HourFormat] = HourFormat.allCases
    
    private var selectedHour: Int?
    private var selectedMinute: Int?
    private var selectedHourFormat: HourFormat?
    
    // MARK: - Views
    public var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    private lazy var colonLabel: UILabel = {
        let label = UILabel()
        let size = Constants.colonFontSize
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        label.text = ":"
        return label
    }()
    
    private var leftConstraintAnchor: NSLayoutConstraint?
    
    public init(format: TimeFormat = .h24) {
        self.timeFormat = format
        self.components = format.components
        self.hours = format.hours
        super.init(frame: .zero)
        setupViews()
        setupCurrentTime()
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
    
    open func setupCurrentTime() {
        let currentTime = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        if var hour = currentTime.hour, components.count > TimeComponent.hour.rawValue {
            if timeFormat == .h12 && hour >= 12 {
                hour -= 12
                selectedHourFormat =  hour < 12 ? .am : .pm
            }
            switch selectedHourFormat {
            case .am:
                pickerView.selectRow(0, inComponent: TimeComponent.format.rawValue, animated: true)
            case .pm:
                pickerView.selectRow(1, inComponent: TimeComponent.format.rawValue, animated: true)
            default:
                break
            }
            print(hour)
            pickerView.selectRow(hour, inComponent: TimeComponent.hour.rawValue, animated: true)
            selectedHour = hour
            
            if let minute = currentTime.minute, components.count > TimeComponent.minute.rawValue {
                pickerView.selectRow(minute, inComponent: TimeComponent.minute.rawValue, animated: true)
                selectedMinute = minute
            }
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
            return hours.count
        case .minute:
            return minutes.count
        case .format:
            return hourFormats.count
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = timeLabelFont ?? UIFont.systemFont(ofSize: Constants.fontSize, weight: .semibold)
        switch components[component]  {
        case .hour:
            label.text = String(format: "%02d", hours[row])
        case .minute:
            label.text = String(format: "%02d", minutes[row])
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
            self.selectedHour = hours[safe: row]
        case .minute:
            self.selectedMinute = minutes[safe: row]
        case .format:
            self.selectedHourFormat = hourFormats[safe: row]
        }
        guard var hour = selectedHour, let minute = selectedMinute else { return }
        var calendar = Calendar.current
        calendar.timeZone = .current
        switch selectedHourFormat {
        case .pm:
            hour += 12
        default:
            break
        }
        print(hour, minute)
        guard let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of:  Date()) else {
            return
        }
        onDateTimePicked?(date)
        onNumberTimePicked?(hour, minute)
    }
}
