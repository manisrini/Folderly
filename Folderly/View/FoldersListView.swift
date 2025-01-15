//
//  FoldersListView.swift
//  Folderly
//
//  Created by Manikandan on 14/01/25.
//

import SwiftUI

struct FoldersListView: View {
    
    @State private var isOptionsSheetPresented = false
    @State private var isAddFolderSheetPresented = false
    @State private var isAttachmentSheetPresented = false

    var isSaveLocal: Bool = true
    var isVideoEnabled: Bool = true
    var isPhotosEnabled: Bool = true
    var isFileEnabled: Bool = true
    
    
    @State private var isImagePickerPresented = false
    @State private var filePath: URL?
    @State private var fileId: UUID?
    @State private var fileName: String = ""
    @State private var showCamera = false
    @State private var showPhotoLibrary = false


    @State private var textFieldStr : String = ""
    
    @ObservedObject var viewModel = FoldersListViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(){
                VStack(alignment : .leading){
                    ForEach(viewModel.listData,id: \.self){ item in
                        NavigationLink {
                            FoldersListView()
                        } label: {
                            ListCellView(
                                name: item.name,
                                createdTime: viewModel.getDateStr(date: item.creationDate),
                                didTapMenu: {
                                print("tapped")
                            })
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Folderly")
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
                        viewModel.addFolder(folderName: textFieldStr)
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
