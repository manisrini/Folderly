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
    let isFavourite : Bool
    
    init(id : UUID?,type: FileType, name: String, creationDate: Date?, image: UIImage? = nil,isFavourite : Bool) {
        self.id = id
        self.type = type
        self.name = name
        self.creationDate = creationDate
        self.image = image
        self.isFavourite = isFavourite
    }
}

class FoldersListViewModel : ObservableObject {
    
    @Published var listData : [ListViewModel] = []
    var foldersList : [ListViewModel] = []
    var folder : ListViewModel? = nil
    var dataManager : FileDataHelper
    
    init(folder : ListViewModel? = nil,dataManager: FileDataHelper = FileDataHelper()) {
        self.dataManager = dataManager
        self.folder = folder
    }
    
    func getListData(){
        if let folder = folder, let folderId = folder.id{ //Has a parent folder
            self.getSubFolders(for: folderId)
            self.getFiles(for: folderId)
        }else{
            self.getFolders()
            self.getFiles()
        }
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
                            creationDate: folder.creationDate,
                            isFavourite: folder.isFavourite
                        )
                    )
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    
    func addSubFolder(subFolderName : String,parentFolderId : UUID?) {
        
        guard let parentFolderId = parentFolderId else{
            return
        }
        
        dataManager.addSubFolder(parentFolderId: parentFolderId, subFolderId: UUID(), subFolderName: subFolderName, creationDate: Date()) { result in
            
            switch result {
            case .success(let subFolder):
                if let subFolder = subFolder{
                    self.listData.append(
                        .init(
                            id : subFolder.id,
                            type: .Folder,
                            name: subFolder.name ?? defaultStr ,
                            creationDate: subFolder.creationDate,
                            isFavourite: subFolder.isFavourite
                        )
                    )
                }
            case .failure(let failure):
                print(failure)
            }
        }
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
                            creationDate: folder.creationDate,
                            isFavourite: folder.isFavourite
                        )
                    )
                }
                self.foldersList = foldersList
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    //MARK: Nested folders
    
    func getSubFolders(for folderId : UUID) {
        dataManager.fetchSubFolders(for: folderId) { result in
            switch result {
            case .success(let subFolders):
                var subFoldersList : [ListViewModel] = []
                for folder in subFolders {
                    subFoldersList.append(
                        .init(
                            id : folder.id,
                            type: .Folder,
                            name: folder.name ?? defaultStr,
                            creationDate: folder.creationDate,
                            isFavourite: folder.isFavourite
                        )
                    )
                }
                self.foldersList = subFoldersList
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    //MARK: root files
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
                                creationDate: file.creationDate,
                                image: _self.getImagePath(relativePath: file.filePath),
                                isFavourite: false
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
    
    
    //MARK: Files inside a folder
    func getFiles(for folderId : UUID) {
        dataManager.fetchFiles(for: folderId) { [weak self] result in
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
                                creationDate: file.creationDate,
                                image: _self.getImagePath(relativePath: file.filePath),
                                isFavourite: false
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
        
        if let folder = folder, let folderId = folder.id{
            
            dataManager.addFileToFolder(toFolderId: folderId, fileId: fileId, fileName: fileName, filePath: filePath, fileType: fileType.rawValue, completion: { [weak self] result in
                
                switch result {
                case .success(let file):
                    if let file = file,let _self = self {
                        _self.listData.append(
                            .init(
                                id : file.id,
                                type: FileType(rawValue: file.type ?? "") ?? .Image,
                                name: file.name ?? defaultStr,
                                creationDate: file.creationDate,
                                image: _self.getImagePath(relativePath: file.filePath),
                                isFavourite: false
                            )
                        )
                    }
                case .failure(let failure):
                    print(failure)
                }
                
            })
            
        }else{
            
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
                                type: FileType(rawValue: file.type ?? "") ?? .Image,
                                name: file.name ?? defaultStr,
                                creationDate: file.creationDate,
                                image: _self.getImagePath(relativePath: file.filePath),
                                isFavourite: false
                            )
                        )
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
    func updateFavourite(for folderIndexPath : IndexPath){
        
        let folder = self.listData[folderIndexPath.row]
        
        guard let id = folder.id else{
            return
        }
        let isFavourite = !folder.isFavourite
        
        dataManager.markFolderAsFavorite(folderId: id, isFavorite: isFavourite) { result in
            switch result {
            case .success(let folder):
                if let folder = folder{
                    self.listData[folderIndexPath.row] = .init(
                        id: folder.id,
                        type: .Folder,
                        name: folder.name ?? defaultStr,
                        creationDate: folder.creationDate,
                        isFavourite: folder.isFavourite
                    )
                }
                print("Marked as favorite: \(folder?.name ?? "")")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: Utils
    func getDateStr(date : Date?) -> String{
        
        let dateStr = "Created on: "
        
        if let date = date{
            return dateStr + Utils.formatDate(date: date)
        }
        return dateStr + defaultStr
    }
    
    func isNestedFolder() -> Bool{
        if folder != nil{
            return true
        }
        return false
    }
    
    func getNavBarTitle() -> String{
        if let folder = folder{
            return folder.name
        }
        return "Folderly"
    }
    
}
