//
//  FoldersListViewModel.swift
//  Folderly
//
//  Created by Manikandan on 14/01/25.
//
import Foundation
import UIKit

let defaultStr = "---"

struct ListViewModel : Hashable {
    let id : UUID?
    let type : FileType
    let name : String
    let creationDate : Date?
    let image : UIImage?
    
    init(id : UUID?,type: FileType, name: String, creationDate: Date?, image: UIImage? = nil) {
        self.id = id
        self.type = type
        self.name = name
        self.creationDate = creationDate
        self.image = image
    }
}

class FoldersListViewModel : ObservableObject {
    
    @Published var listData : [ListViewModel] = []
    var foldersList : [ListViewModel] = []
    var folderId : UUID? = nil
    var dataManager : FileDataHelper
    
    init(folderId : UUID? = UUID(uuidString: ""),dataManager: FileDataHelper = FileDataHelper()) {
        self.dataManager = dataManager
        self.folderId = folderId
    }
    
    func addFolder(folderName : String) {
        dataManager.addFolder(id: UUID(), name: folderName, creationDate: Date()) { result in
            switch result {
            case .success(let folder):
                if let folder = folder{
                    self.listData.append(
                        .init(
                            id : folder.id,
                            type: .Folder,
                            name: folder.name ?? defaultStr ,
                            creationDate: folder.creationDate
                        )
                    )
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    
    func getFoldersAndFiles(){
        self.getFolders()
        self.getFiles()
    }
    
    func getFolders() {
        dataManager.fetchAllFolders { result in
            switch result {
            case .success(let folders):
                var foldersList : [ListViewModel] = []
                for folder in folders {
                    foldersList.append(
                        .init(
                            id : folder.id,
                            type: .Folder,
                            name: folder.name ?? defaultStr,
                            creationDate: folder.creationDate
                        )
                    )
                }
                self.foldersList = foldersList
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func getFiles() {
        dataManager.fetchFilesWithoutFolder { [weak self] result in
            switch result {
            case .success(let files):
                if let _self = self{
                    var filesList : [ListViewModel] = []
                    
                    for file in files{
                        filesList.append(
                            .init(
                                id : file.id,
                                type: FileType(rawValue: file.type ?? defaultStr) ?? .Image,
                                name: file.name ?? defaultStr ,
                                creationDate: file.creationDate, //Need to get from db
                                image: _self.getImagePath(relativePath: file.filePath)
                            )
                        )
                    }
                    _self.foldersList.append(contentsOf: filesList)
                    _self.listData = _self.foldersList
                }
                
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func getImagePath(relativePath : String?) -> UIImage? {
        if let relativePath = relativePath{
            let fileManager = FileManager.default
            if let documentDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
                let filePath = documentDir.appending(path: relativePath)
                if let imageData = try? Data(contentsOf: filePath){
                    return UIImage(data: imageData)
                }
            }
        }
        return nil
    }
    
    func addFile(fileId : UUID,fileName : String,filePath : String,fileType : FileType){
        
        dataManager.addFile(
            fileId: fileId,
            fileName: fileName,
            filePath: filePath,
            fileType: fileType.rawValue
        ) { [weak self] result in
            switch result {
            case .success(let file):
                if let file = file,let _self = self {
                    _self.listData.append(
                        .init(
                            id : file.id,
                            type: .Image,
                            name: file.name ?? defaultStr,
                            creationDate: file.creationDate,
                            image: _self.getImagePath(relativePath: file.filePath)
                        )
                    )
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func getDateStr(date : Date?) -> String{
        
        let dateStr = "Created on: "
        
        if let date = date{
            return dateStr + Utils.formatDate(date: date)
        }
        return dateStr + defaultStr
    }
}
