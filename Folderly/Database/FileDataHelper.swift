//
//  FileDataHelper.swift
//  Folderly
//
//  Created by Manikandan on 10/01/25.
//

import Foundation
import CoreData

enum Entity : String{
    case File = "File"
    case Folder = "Folder"
}

class FileDataHelper {
    
    let dbManager = DBManager()
    

    func addFolder(
        id: UUID,
        name: String,
        isFavorite: Bool = false,
        creationDate: Date,
        parentFolder: Folder? = nil,
        completion: @escaping (Result<Folder?, Error>) -> Void
    ) {
        let managedContext = dbManager.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: Entity.Folder.rawValue, in: managedContext) {
            
            if let dbObj = NSManagedObject(entity: entity, insertInto: managedContext) as? Folder{
                dbObj.id = id
                dbObj.name = name
                dbObj.isFavourite = isFavorite
                dbObj.creationDate = creationDate
                if let parentFolder = parentFolder{
                    dbObj.parentFolder = parentFolder
                }
                
                
                dbManager.saveContext(managedObjectContext: managedContext) { result in
                    switch result {
                    case .success(_):
                        completion(.success(dbObj))
                    default:
                        completion(.failure(NSError(domain: "CoreDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to save"])))
                    }
                }
            }

        }
    }
    
    
    public func addSubFolder(
        parentId: UUID,
        subFolderId: UUID,
        subFolderName: String,
        isFavorite: Bool = false,
        creationDate: Date,
        completion: @escaping (Result<Folder?, Error>) -> Void
    ) {
        let managedContext = dbManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", parentId as CVarArg)
        
        do {
            if let parentFolder = try managedContext.fetch(fetchRequest).first {
                if let entity = NSEntityDescription.entity(forEntityName: Entity.Folder.rawValue, in: managedContext) {
                    if let subFolder = NSManagedObject(entity: entity, insertInto: managedContext) as? Folder {
                        subFolder.id = subFolderId
                        subFolder.name = subFolderName
                        subFolder.isFavourite = isFavorite
                        subFolder.creationDate = creationDate
                        subFolder.parentFolder = parentFolder
                        
                        dbManager.saveContext(managedObjectContext: managedContext) { result in
                            switch result {
                            case .success:
                                completion(.success(subFolder))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    } else {
                        completion(.failure(NSError(domain: "CoreDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create subfolder"])))
                    }
                } else {
                    completion(.failure(NSError(domain: "CoreDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Entity description not found"])))
                }
            } else {
                completion(.failure(NSError(domain: "CoreDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Parent folder not found"])))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    
    func addFile(
        toFolderId: UUID,
        fileId: UUID,
        fileName: String,
        filePath: String,
        fileType: String,
        completion: @escaping (Result<File?, Error>) -> Void
    ) {
        let managedContext = dbManager.persistentContainer.viewContext
        
        // Fetch the target folder
        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", toFolderId as CVarArg)
        
        do {
            if let folder = try managedContext.fetch(fetchRequest).first {
                // Create a new file
                if let entity = NSEntityDescription.entity(forEntityName: Entity.File.rawValue, in: managedContext) {
                    if let newFile = NSManagedObject(entity: entity, insertInto: managedContext) as? File {
                        newFile.id = fileId
                        newFile.name = fileName
                        newFile.filePath = filePath
                        newFile.type = fileType
                        newFile.folder = folder
                        
                        dbManager.saveContext(managedObjectContext: managedContext) { result in
                            switch result {
                            case .success:
                                completion(.success(newFile))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    } else {
                        completion(.failure(NSError(domain: "CoreDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create file"])))
                    }
                } else {
                    completion(.failure(NSError(domain: "CoreDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Entity description not found"])))
                }
            } else {
                completion(.failure(NSError(domain: "CoreDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Folder not found"])))
            }
        } catch {
            completion(.failure(error))
        }
    }

    
    func fetchAllFolders(completion: @escaping (Result<[Folder], Error>) -> Void) {
        let managedContext = dbManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        
        do {
            let folders = try managedContext.fetch(fetchRequest)
            completion(.success(folders))
        } catch {
            completion(.failure(error))
        }
    }

    
}
