//
//  FoldersListViewModel.swift
//  Folderly
//
//  Created by Manikandan on 14/01/25.
//
import Foundation


let defaultStr = "---"

struct ListViewModel : Hashable {
    let type : FileType
    let name : String
    let creationDate : Date?
}

class FoldersListViewModel : ObservableObject {
    
    @Published var listData : [ListViewModel] = []
    var dataManager : FileDataHelper
    
    init(dataManager: FileDataHelper = FileDataHelper()) {
        self.dataManager = dataManager
    }
    
    func addFolder(folderName : String) {
        dataManager.addFolder(id: UUID(), name: folderName, creationDate: Date()) { result in
            switch result {
            case .success(let folder):
                if let folder = folder{
                    self.listData.append(
                        .init(
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
    
    func getFolders() {
        dataManager.fetchAllFolders { result in
            switch result {
            case .success(let folders):
                var tempListData : [ListViewModel] = []
                for folder in folders{
                    tempListData.append(
                        .init(
                            type: .Folder,
                            name: folder.name ?? defaultStr ,
                            creationDate: folder.creationDate
                        )
                    )
                }
                self.listData = tempListData
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    
    func addFile(fileId : UUID,fileName : String,filePath : URL?,fileType : FileType){
        dataManager.addFile(
            fileId: fileId,
            fileName: fileName,
            filePath: "\(String(describing: filePath))",
            fileType: fileType.rawValue
        ) { result in
            switch result {
            case .success(let file):
                if let file = file{
                    self.listData.append(
                        .init(
                            type: .Image,
                            name: file.name ?? defaultStr,
                            creationDate: Date()
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
        return dateStr + "---"
    }
}
