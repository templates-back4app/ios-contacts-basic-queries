//
//  QueryController.swift
//  DSSContacts
//
//  Created by David on 07/04/22.
//

import UIKit

extension UIColor {
    static let primary: UIColor = UIColor(red: 11 / 255, green: 140 / 255, blue: 229 / 255, alpha: 1)
}

extension UIButton {
    convenience init(title: String) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        backgroundColor = .primary
        tintColor = .white
        layer.cornerRadius = 8
    }
}

class QueryController: UIViewController {
    private let queryByNameButton: UIButton = {
        let button = UIButton(title: "By name")
        return button
    }()
    
    private let queryFriendCountButton: UIButton = {
        let button = UIButton(title: "By friend count")
        return button
    }()
    
    private let queryOrderingButton: UIButton = {
        let button = UIButton(title: "Ordering")
        return button
    }()
    
    private let queryAllButton: UIButton = {
        let button = UIButton(title: "All")
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        let formStackView = UIStackView(arrangedSubviews: [
            SectionLabel(title: "Queries"),
            queryByNameButton,
            queryFriendCountButton,
            queryOrderingButton,
            queryAllButton
        ])
        formStackView.distribution = .fillEqually
        formStackView.spacing = 8
        formStackView.axis = .vertical
        formStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let numberOfStackedViews = formStackView.arrangedSubviews.count
        let stackViewHeight = (formStackView.spacing + 44) * CGFloat(numberOfStackedViews) - formStackView.spacing
            
        view.addSubview(formStackView)
        formStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        formStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        formStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -16).isActive = true
        formStackView.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        
        queryByNameButton.addTarget(self, action: #selector(handleByName), for: .touchUpInside)
        queryFriendCountButton.addTarget(self, action: #selector(handleByFriendCount), for: .touchUpInside)
        queryOrderingButton.addTarget(self, action: #selector(handleOrdering), for: .touchUpInside)
        queryAllButton.addTarget(self, action: #selector(handleAll), for: .touchUpInside)
    }
    
    @objc private func handleByName() {
        presentForm(title: "Query by name", description: "Enter a name", placeholder: nil) { [weak self] name in
            guard let self = self else { return }
            
            guard let name = name else {
                return self.showAlert(title: "Error", message: "Invalid name.")
            }
            
            let contactsController = ContactsController(queryType: .byName(value: name))
            
            self.navigationController?.pushViewController(contactsController, animated: true)
        }
    }
    
    @objc private func handleByFriendCount() {
        presentForm(title: "Query by number of friend", description: "Enter a minimum number of friends", placeholder: nil) { [weak self] numberString in
            guard let self = self else { return }
            
            guard let numberString = numberString, let number = Int(numberString) else {
                return self.showAlert(title: "Error", message: "Invalid number of friends.")
            }
            
            let contactsController = ContactsController(queryType: .byNumberOfFriends(quantity: number))
            
            self.navigationController?.pushViewController(contactsController, animated: true)
        }
    }
    
    @objc private func handleOrdering() {
        let alertController = UIAlertController(title: "Ordering by birthdate", message: nil, preferredStyle: .actionSheet)
        
        let ascendingAction = UIAlertAction(title: "Ascending", style: .default) { [weak self] _ in
            let contactsController = ContactsController(queryType: .byOrdering(order: .ascending))
            self?.navigationController?.pushViewController(contactsController, animated: true)
        }
        
        let descendingAction = UIAlertAction(title: "Descending", style: .default) { [weak self] _ in
            let contactsController = ContactsController(queryType: .byOrdering(order: .descending))
            self?.navigationController?.pushViewController(contactsController, animated: true)
        }
        
        alertController.addAction(ascendingAction)
        alertController.addAction(descendingAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleAll() {
        let contactsController = ContactsController(queryType: .all)
        
        self.navigationController?.pushViewController(contactsController, animated: true)
    }

    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
        
        setupNavigationBar(with: "Basic Queries")
    }
    
    @objc private func handleAdd() {
        let newContactController = NewContactController()
        
        present(UINavigationController(rootViewController: newContactController), animated: true, completion: nil)
    }
}
