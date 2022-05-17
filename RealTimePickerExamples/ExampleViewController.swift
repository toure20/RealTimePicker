//
//  ViewController.swift
//  RealTimePickerExamples
//
//  Created by Admin on 24.04.2022.
//

import UIKit
import RealTimePicker

class ExampleViewController: UIViewController {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "RealTimePickerView"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private var bgImageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "main_bg"))
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private var selectedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "Select time"
        label.textColor = .white
        return label
    }()
    
    private var timePicker: RealTimePickerView = {
        let view = RealTimePickerView(format: .h24)
        view.rowHeight = 60 // default row height is 60
        view.timeLabelFont = UIFont.systemFont(ofSize: 44, weight: .semibold) // default size
        view.colonLabelFont = UIFont.systemFont(ofSize: 44 * 0.75, weight: .bold) // default size
        view.formatLabelFont = UIFont.systemFont(ofSize: 24, weight: .semibold) // default size
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 24
        view.showCurrentTime = true
        return view
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let view = UISegmentedControl(items: ["24-hour", "12-hour"])
        view.addTarget(self, action: #selector(didSelectSegment(_:)), for: .valueChanged)
        view.backgroundColor = .white
        view.selectedSegmentIndex = 0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupEvents()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(bgImageView)
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bgImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bgImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        
        view.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        view.addSubview(selectedLabel)
        selectedLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectedLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44).isActive = true
        
        view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        segmentControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        segmentControl.bottomAnchor.constraint(equalTo: selectedLabel.topAnchor, constant: -24).isActive = true
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
    
    @objc private func didSelectSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            timePicker.update(timeFormat: .h24)
        case 1:
            timePicker.update(timeFormat: .h12)
        default:
            break
        }
    }
}

