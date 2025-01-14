//
//  Folder+CoreDataProperties.swift
//  Folderly
//
//  Created by Manikandan on 14/01/25.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var name: String?
    @NSManaged public var files: NSSet?
    @NSManaged public var parentFolder: Folder?
    @NSManaged public var subFolders: NSSet?

}

// MARK: Generated accessors for files
extension Folder {

    @objc(addFilesObject:)
    @NSManaged public func addToFiles(_ value: File)

    @objc(removeFilesObject:)
    @NSManaged public func removeFromFiles(_ value: File)

    @objc(addFiles:)
    @NSManaged public func addToFiles(_ values: NSSet)

    @objc(removeFiles:)
    @NSManaged public func removeFromFiles(_ values: NSSet)

}

// MARK: Generated accessors for subFolders
extension Folder {

    @objc(addSubFoldersObject:)
    @NSManaged public func addToSubFolders(_ value: Folder)

    @objc(removeSubFoldersObject:)
    @NSManaged public func removeFromSubFolders(_ value: Folder)

    @objc(addSubFolders:)
    @NSManaged public func addToSubFolders(_ values: NSSet)

    @objc(removeSubFolders:)
    @NSManaged public func removeFromSubFolders(_ values: NSSet)

}

extension Folder : Identifiable {

}
