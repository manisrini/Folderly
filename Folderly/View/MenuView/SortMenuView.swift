//
//  SortMenuView.swift
//  Folderly
//
//  Created by Manikandan on 20/01/25.
//
import SwiftUI

struct SortMenuView : View {
    
   @Binding var items : [ListViewModel]
        
    var body : some View{
        Menu {
            Button{
                self.sortByName()
            } label: {
                Label("Name", systemImage: "textformat")
            }
            
            Button{
                self.sortByDate()
            }label: {
                Label("Date", systemImage: "calendar")
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .resizable()
                .frame(width: 20, height: 17)
                .foregroundStyle(.blue)
        }

    }
    
    private func sortByDate() {
        
        let folders = self.items.filter { model in
            model.type == .Folder
        }
        
        let files = self.items.filter { model in
            model.type == .Image || model.type == .Pdf
        }
        
        let sortedFolders = folders.sorted { prev, current in
            prev.creationDate ?? Date() > current.creationDate ?? Date()
        }
        
        self.items = sortedFolders + files
    }
    
    private func sortByName() {
        let folders = self.items.filter { model in
            model.type == .Folder
        }
        
        let files = self.items.filter { model in
            model.type == .Image || model.type == .Pdf
        }
        
        let sortedFolders = folders.sorted { prev, current in
            prev.name < current.name
        }
        
        self.items = sortedFolders + files

    }
    

}
