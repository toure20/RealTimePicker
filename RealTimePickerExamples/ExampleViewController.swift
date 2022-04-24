//
//  ViewController.swift
//  RealTimePickerExamples
//
//  Created by Admin on 24.04.2022.
//

import UIKit
import RealTimePicker

class ExampleViewController: UIViewController {
    
    private var selectedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Select time"
        return label
    }()
    
    private var timePicker: RealTimePickerView = {
        let view = RealTimePickerView()
        view.rowHeight = 80 // default row height is 80
        view.colonLabelFont = UIFont.systemFont(ofSize: 40, weight: .bold) // default size is 40
        view.timeLabelFont = UIFont.systemFont(ofSize: 54, weight: .semibold) // default size is 54
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupEvents()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        
        view.addSubview(selectedLabel)
        selectedLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectedLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44).isActive = true
    }

    private func setupEvents() {
        timePicker.onDateTimePicked = { date in
            print(date)
        }
        timePicker.onNumberTimePicked = { hour, minute in
            self.selectedLabel.text = [hour, minute].compactMap {
                String(format: "%02d", $0)
            }.joined(separator: ":")
        }
    }
}

