//
//  Contact.swift
//  DSSContacts
//
//  Created by David on 10/04/22.
//

import Foundation
import ParseSwift

struct Contact: ParseObject {
    // Required properties from ParseObject protocol
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    // Custom fields for the contact's information
    var name: String?
    var birthday: Date?
    var numberOfFriends: Int?
    var favoriteFoods: [String]?
    
    // Implement your own version of merge
    func merge(with object: Self) throws -> Self {
        var updated = try merge(with: object)
        
        if updated.shouldRestoreKey(\.name, original: object) { updated.name = object.name }
        if updated.shouldRestoreKey(\.birthday, original: object) { updated.birthday = object.birthday }
        if updated.shouldRestoreKey(\.numberOfFriends, original: object) { updated.numberOfFriends = object.numberOfFriends }
        if updated.shouldRestoreKey(\.favoriteFoods, original: object) { updated.favoriteFoods = object.favoriteFoods }
        
        return updated
    }
}
