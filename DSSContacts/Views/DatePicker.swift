//
//  DatePicker.swift
//  DSSContacts
//
//  Created by David on 10/04/22.
//

import Foundation
import UIKit

class DatePicker: UIControl {
    // MARK: - Properties
    
    var dateDescription: String? {
        get { descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var datePicker: UIDatePicker = {
        let control = UIDatePicker()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.datePickerMode = .date
        return control
    }()
    
    var date: Date {
        get { datePicker.date }
        set { datePicker.date = newValue }
    }
    
    // MARK: - Init
    
    convenience init(description: String) {
        self.init()
        defer { self.dateDescription = description }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Handlers
    
    private func setupViews() {
        addSubview(descriptionLabel)
        addSubview(datePicker)
                
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        datePicker.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
