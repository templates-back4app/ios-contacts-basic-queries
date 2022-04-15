//
//  ContactsController.swift
//  DSSContacts
//
//  Created by David on 10/04/22.
//

import Foundation
import UIKit
import ParseSwift

fileprivate class ContactCell: UITableViewCell {
    class var identifier: String { "\(NSStringFromClass(Self.self)).identifier" }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        detailTextLabel?.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ContactsController: UITableViewController {
    // MARK: - Properties
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        return formatter
    }()
    
    private let queryType: QueryType
    
    private var contacts: [Contact] = []
    
    // MARK: - Init
    
    init(queryType: QueryType) {
        self.queryType = queryType
        
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(with: queryType.description)
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchContacts()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = .init()
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
    }
    
    private func fetchContacts() {
        // We create a Query<Contact> according to the queryType enumeration
        let query: Query<Contact> = {
            switch queryType {
            case .byName(let value):
                return Contact.query(containsString(key: "name", substring: value))
            case .byNumberOfFriends(let quantity):
                return Contact.query("numberOfFriends" >= quantity)
            case .byOrdering(let order):
                let query = Contact.query()
                switch order {
                case .ascending: return query.order([.ascending("birthday")])
                case .descending: return query.order([.descending("birthday")])
                }
            case .all:
                return Contact.query()
            }
        }()
        
        // Execute the query
        query.find { [weak self] result in
            switch result {
            case .success(let contacts):
                self?.contacts = contacts
                
                // Update the UI
                DispatchQueue.main.async { self?.tableView.reloadData() }
            case .failure(let error):
                // Notify the user about the error that happened during the fetching process
                self?.showAlert(title: "Error", message: "Failed to retrieve contacts: \(error.message)")
                return
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ContactsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as! ContactCell
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        let birthDate = dateFormatter.string(from: contact.birthday ?? Date())
        cell.detailTextLabel?.text = "Friends: \(contact.numberOfFriends ?? 0)\nBirthday: \(birthDate)"
        return cell
    }
}
