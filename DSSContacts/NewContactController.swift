//
//  NewContactController.swift
//  DSSContacts
//
//  Created by David on 10/04/22.
//

import Foundation
import UIKit
import ParseSwift

class NewContactController: UIViewController {
    private let nameTextField: TextField = TextField(placeholder: "Name")
    
    private let birthdayDatePicker: DatePicker = DatePicker(description: "Birthday")
    
    private let numberOfFriendsTextField: TextField = {
        let textField = TextField(placeholder: "Number of friends")
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let favoriteFoodsTextField: TextField = TextField(placeholder: "Favorite foods (separated by commas)")
    
    private let addButton: UIButton = UIButton(title: "Add")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleClose))
        cancelButton.tintColor = .white
        navigationItem.rightBarButtonItem = cancelButton
        
        setupNavigationBar(with: "New contact")
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        let formStackView = UIStackView(arrangedSubviews: [
            nameTextField,
            birthdayDatePicker,
            numberOfFriendsTextField,
            favoriteFoodsTextField,
            addButton
        ])
        
        formStackView.axis = .vertical
        formStackView.distribution = .fillEqually
        formStackView.spacing = 8
        formStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let numberOfStackedViews = formStackView.arrangedSubviews.count
        let stackViewHeight = (formStackView.spacing + 44) * CGFloat(numberOfStackedViews) - formStackView.spacing
            
        view.addSubview(formStackView)
        formStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        formStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        formStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -16).isActive = true
        formStackView.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        
        addButton.addTarget(self, action: #selector(handleAddContact), for: .touchUpInside)
        
        view.setupHideKeyboardTap()
    }
    
    @objc private func handleClose() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ParseSwift

extension NewContactController {
    /// Retrieves the info the user entered for a new contact and stores it on your Back4App Database
    @objc fileprivate func handleAddContact() {
        view.endEditing(true)
        
        // Collect the contact's information from the form
        guard let name = nameTextField.text,
              let numberOfFriendsString = numberOfFriendsTextField.text,
              let numberOfFriends = Int(numberOfFriendsString),
              let favoriteFoods = favoriteFoodsTextField.text?.split(separator: ",") else {
            return showAlert(title: "Error", message: "The data you entered is con valid.")
        }
        
        // Once the contact's information is collected, instantiate a Contact object to save it on your Back4App Database
        let contact = Contact(
            name: name,
            birthday: birthdayDatePicker.date,
            numberOfFriends: numberOfFriends,
            favoriteFoods: favoriteFoods.compactMap { String($0).trimmingCharacters(in: .whitespaces) }
        )
        
        // Save the new Contact
        contact.save { [weak self] result in
            switch result {
            case .success(_):
                self?.showAlert(title: "Success", message: "Contact saved.") {
                    self?.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                self?.showAlert(title: "Error", message: "Failed to save contact: \(error.message)")
            }
        }
    }
}
