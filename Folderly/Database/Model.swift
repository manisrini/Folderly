//
//  Model.swift
//  Folderly
//
//  Created by Manikandan on 10/01/25.
//

import Foundation

struct FolderModel{
    let id: UUID = UUID()
    let creationDate: Date
    let isFavorite : Bool?
    let files : FileModel
    let name : String
    let subFolders : [FolderModel]?
    
    init(creationDate: Date, isFavorite: Bool?, files: FileModel, name: String, subFolders: [FolderModel]?) {
        self.creationDate = creationDate
        self.isFavorite = isFavorite
        self.files = files
        self.name = name
        self.subFolders = subFolders
    }
}


struct FileModel {
    let id: UUID = UUID()
    let name : String
    let fileType : String
    let filePath : String
    
    init(name: String, fileType: String, filePath: String) {
        self.name = name
        self.fileType = fileType
        self.filePath = filePath
    }
}
