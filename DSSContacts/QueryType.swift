//
//  QueryType.swift
//  DSSContacts
//
//  Created by David on 10/04/22.
//

import Foundation

enum QueryType {
    enum Ordering {
        case ascending, descending
    }
    
    case byName(value: String)
    case byNumberOfFriends(quantity: Int)
    case byOrdering(order: Ordering), all
    
    /// A short description about the QueryType
    var description: String {
        switch self {
        case .byName(let value): return "Contacts with name: \(value)"
        case .byNumberOfFriends(let quantity): return "Contacts with \(quantity)+ friends"
        case .byOrdering(order: let order): return "Birthday (\(order == .ascending ? "ascending" : "descending"))"
        case .all: return "All contacts"
        }
    }
}
