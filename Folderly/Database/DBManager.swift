//
//  DBManager.swift
//  Folderly
//
//  Created by Manikandan on 09/01/25.
//

import Foundation
import CoreData

class DBManager{
    let dbName = "Folderly"
    static let shared = DBManager()
    
    public lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: dbName)
        container.loadPersistentStores { storeDesc, error in
            if let _error = error as NSError?{
                print(_error.localizedDescription)
            }
        }
        return container
    }()
    
    func saveContext(managedObjectContext: NSManagedObjectContext, completionHandler: @escaping(Result<String,Error>) -> Void){
        do {
            try managedObjectContext.save()
            completionHandler(.success("Saved to DB Successfully"))
        } catch let error {
            completionHandler(.failure(error))
        }
    }
}
