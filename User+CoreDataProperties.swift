//
//  User+CoreDataProperties.swift
//  
//
//  Created by Blain Ellis on 19/09/2019.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var token: String?
    @NSManaged public var identifier: String?
    @NSManaged public var username: String?

}
