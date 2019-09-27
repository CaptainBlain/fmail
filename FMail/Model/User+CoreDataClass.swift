//
//  User+CoreDataClass.swift
//  
//
//  Created by Blain Ellis on 19/09/2019.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

    public static func getUser(context:NSManagedObjectContext) -> User? {
        
        var user:User?;
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            if (result.count > 0) {
                user = result[0] as? User
            }
            
        } catch {
            print("Failed to get user")
        }
        
        return user;
    }
    
    public static func createUser(fromMapper mapper: UserMapper) {
        
        let context = DatabaseController.shared.persistentContainer.viewContext
        
        let user = DatabaseController.shared.addUser()
        user.identifier = mapper._id
        user.username = mapper.username
        user.token = mapper.token
        
        do {
            try context.save()
            
        } catch {
            print("Failed saving")
        }
        
    }
    
}
