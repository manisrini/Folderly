//
//  FoldersListView.swift
//  Folderly
//
//  Created by Manikandan on 14/01/25.
//

import SwiftUI

struct FoldersListView: View {
    
    
    var parentFolderId : UUID? = nil
    
    @State private var isOptionsSheetPresented = false
    @State private var isAddFolderSheetPresented = false
    @State private var isAttachmentSheetPresented = false

    var isSaveLocal: Bool = true
    var isVideoEnabled: Bool = true
    var isPhotosEnabled: Bool = true
    var isFileEnabled: Bool = true
    
    
    @State private var isImagePickerPresented = false
    @State private var filePath: String = ""
    @State private var fileId: UUID?
    @State private var fileName: String = ""
    @State private var showCamera = false
    @State private var showPhotoLibrary = false

    @State private var textFieldStr : String = ""
    
    @ObservedObject var viewModel : FoldersListViewModel
    
    init(viewModel : FoldersListViewModel){
        self.viewModel = viewModel
        print("folder id => \(viewModel.folder)")
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.listData,id: \.self) { item in
                        if item.type == .Folder{
                            NavigationLink{
                                FoldersListView(viewModel: FoldersListViewModel(folder: item))
                                    .toolbarRole(.editor) //remove the "back" in navbar
                            } label : {
                                FolderCellView (
                                    name: item.name,
                                    createdTime: viewModel.getDateStr(date: item.creationDate)
                                )
                            }
                            .buttonStyle(.plain)
                        }else{
                            FileCellView(
                                image: item.image,
                                name: item.name,
                                createdTime: viewModel.getDateStr(date: item.creationDate)
                            )
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(self.viewModel.getNavBarTitle())
                        .font(.title)
                }
                ToolbarItem {
                    Button {
                        isOptionsSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isOptionsSheetPresented) {
                BottomSheetComponent(
                    showAddSheet: $isAddFolderSheetPresented,
                    showOptionsSheet: $isOptionsSheetPresented,
                    showAttachmentSheet: $isAttachmentSheetPresented
                )
                .presentationDetents([.height(200)])
            }
            .sheet(isPresented: $isAddFolderSheetPresented) {
                AddFolderView(
                    textFieldStr: $textFieldStr,
                    isAddSheetPresented: $isAddFolderSheetPresented,
                    didClickAdd: {
                        if let _folder = viewModel.folder{
                            viewModel.addSubFolder(subFolderName: textFieldStr, parentFolderId: _folder.id)
                        }else{
                            viewModel.addFolder(folderName: textFieldStr)
                        }
                        textFieldStr.removeAll()
                    }
                )
                .padding()
                .presentationDetents([.height(200)])
            }
            .confirmationDialog("Choose an Option", isPresented: $isAttachmentSheetPresented) {
                
                Button {
                    showCamera = true
                } label: {
                    Text("Camera")
                }
                
                if isPhotosEnabled {
                    Button {
                        showPhotoLibrary = true
                    } label: {
                        Text("Photos Library")
                    }
                }
                
                if isFileEnabled {
                    Button {
                    } label: {
                        Text("File Library")
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $showCamera) {
                ImagePicker(
                    sourceType: .camera,
                    isImagePickerPresented: $showCamera,
                    filePath: $filePath,
                    fileId: $fileId,
                    fileName: $fileName
                )
            }
            .sheet(isPresented: $showPhotoLibrary) {
                ImagePicker(
                    sourceType: .photoLibrary,
                    isImagePickerPresented: $showPhotoLibrary,
                    filePath: $filePath,
                    fileId: $fileId,
                    fileName: $fileName
                )
            }
            .onChange(of: filePath) {
                oldValue,
                newValue in
                self.viewModel.addFile(
                    fileId: fileId ?? UUID(),
                    fileName: fileName,
                    filePath: filePath,
                    fileType: .Image
                )
            }
            
            if viewModel.listData.isEmpty{
                VStack{
                    Text("No data found")
                    Spacer()
                }
            }
        }
        .onAppear{
            if let directoryLocation = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
                print("Core Data Path : Documents Directory: \(directoryLocation) Application Support")
            }
            viewModel.getListData()
        }
    }

}

#Preview {
    FoldersListView(viewModel: FoldersListViewModel())
}
