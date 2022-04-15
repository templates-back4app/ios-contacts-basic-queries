//
//  UIViewControllerExtension.swift
//  DSSContacts
//
//  Created by David on 10/04/22.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let backAction = UIAlertAction(title: "Back", style: .default) { _ in
            alertController.dismiss(animated: true, completion: completion)
        }
                
        alertController.addAction(backAction)
        
        DispatchQueue.main.async { self.present(alertController, animated: true, completion: nil) }
    }
    
    func setupNavigationBar(with title: String) {
        navigationController?.navigationBar.barTintColor = .primary
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = title
    }
    
    func presentForm(
        title: String,
        description: String?,
        placeholder: String?,
        submitBlock: @escaping (String?) -> Void
    ) {
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            let text = alertController.textFields?.first?.text
            submitBlock(text)
        }
        alertController.addAction(submitAction)
        
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        
        present(alertController, animated: true, completion: nil)
    }
}

extension UIView {
    func setupHideKeyboardTap() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEndEditingCode)))
    }
    
    @objc private func handleEndEditingCode() {
        endEditing(true)
    }
}
