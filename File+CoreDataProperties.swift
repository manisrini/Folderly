//
//  File+CoreDataProperties.swift
//  Folderly
//
//  Created by Manikandan on 14/01/25.
//
//

import Foundation
import CoreData


extension File {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<File> {
        return NSFetchRequest<File>(entityName: "File")
    }

    @NSManaged public var filePath: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var folder: Folder?

}

extension File : Identifiable {

}
