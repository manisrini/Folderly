//
//  FoldersListView.swift
//  Folderly
//
//  Created by Manikandan on 14/01/25.
//

import SwiftUI

struct FoldersListView: View {
    
    @State private var isOptionsSheetPresented = false
    @State private var isAddSheetPresented = false
    @State private var textFieldStr : String = ""
    
    @ObservedObject var viewModel = FoldersListViewModel()

    var body: some View {
        NavigationView {
            ScrollView(){
                ForEach(viewModel.folders,id: \.id){ folder in
                    NavigationLink {
                        Text(folder.name ?? "")
                            .foregroundStyle(Color.black)
                    } label: {
                        Text(folder.name ?? "")
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        isOptionsSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isOptionsSheetPresented) {
                BottomSheetComponent(showAddSheet: $isAddSheetPresented, showOptionsSheet: $isOptionsSheetPresented)
                    .presentationDetents([.height(200)])
            }
            .sheet(isPresented: $isAddSheetPresented) {
                AddFolderView(
                    textFieldStr: $textFieldStr,
                    isAddSheetPresented: $isAddSheetPresented,
                    didClickAdd: {
                        print(textFieldStr)
                        viewModel.addFolder(folderName: textFieldStr)
                        textFieldStr.removeAll()
                    }
                )
                .padding()
                .presentationDetents([.height(200)])
            }
        }
        .onAppear{
            if let directoryLocation = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
                        print("Core Data Path : Documents Directory: \(directoryLocation)Application Support")
             }
            viewModel.getFolders()
        }
    }

}

#Preview {
    FoldersListView()
}
