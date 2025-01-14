//
//  FoldersListViewModel.swift
//  Folderly
//
//  Created by Manikandan on 14/01/25.
//
import Foundation

class FoldersListViewModel : ObservableObject {
    
    @Published var folders : [Folder] = []
    var dataManager : FileDataHelper
    
    init(dataManager: FileDataHelper = FileDataHelper()) {
        self.dataManager = dataManager
    }
    
    func addFolder(folderName : String) {
        dataManager.addFolder(id: UUID(), name: folderName, creationDate: Date()) { result in
            switch result {
            case .success(let folder):
                if let folder = folder{
                    self.folders.append(folder)
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
                self.folders = folders
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
