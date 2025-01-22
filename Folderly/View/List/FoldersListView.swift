//
//  FoldersListView.swift
//  Folderly
//
//  Created by Manikandan on 14/01/25.
//

import SwiftUI

struct FoldersListView: View {
    
    var parentFolderId : UUID? = nil
    
    @State private var isAttachmentSheetPresented = false
    @State private var isAddFolderSheetPresented = false
    
    @State private var filePath: String = ""
    @State private var fileId: UUID?
    @State private var fileName: String = ""
    @State private var showFiles = false
    @State private var showPhotoLibrary = false
    @State private var isPickerPresented = false
    @State private var pickerType: PickerType = .image
    @State private var fileExt: FileType = .Image
    
    @State private var textFieldStr : String = ""
    
    @ObservedObject var viewModel : FoldersListViewModel
    
    @State private var showMenu = false
    @State private var longPressedItemIndexPath: IndexPath = IndexPath(row: 0, section: 0)

    @State private var isPreviewPresented: Bool = false
    
    var onFolderTap: ((ListViewModel) -> Void)?
    var onFileTap: ((ListViewModel) -> Void)?

    init(viewModel : FoldersListViewModel,onFolderTap: ((ListViewModel) -> Void)? = nil,onFileTap: ((ListViewModel) -> Void)? = nil){
        print("init foldersListView \(viewModel)\n")
        self.viewModel = viewModel
        self.onFileTap = onFileTap
        self.onFolderTap = onFolderTap
    }
    
    var body: some View {
            CollectionViewRepresentable(
                items: $viewModel.listData,
                onFolderTapped: { folder in
                    self.onFolderTap?(folder)
                }, onFileTapped: { file in
                    self.onFileTap?(file)
                },
                onLongPress: { indexPath in
                    if indexPath.row < viewModel.listData.count {
                        DispatchQueue.main.async {
                            showMenu = true
                            longPressedItemIndexPath = indexPath

                        }
                    }
                }
            )
            .sheet(isPresented: $viewModel.isOptionsSheetPresented) {
                OptionsComponent(
                    showAddSheet: $isAddFolderSheetPresented,
                    showOptionsSheet: $viewModel.isOptionsSheetPresented,
                    showAttachmentSheet: $isAttachmentSheetPresented
                )
                .presentationDetents([.height(100)])
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
                    pickerType = .document
                    showFiles = true
                } label: {
                    Text("Document")
                }
                
                Button {
                    pickerType = .image
                    showPhotoLibrary = true
                } label: {
                    Text("Photos Library")
                }
                
                Button("Cancel", role: .cancel) {}
            }
            .sheet(isPresented: $showMenu){
                LongPressOptionsView(item: self.viewModel.listData[longPressedItemIndexPath.row]) {
                    self.viewModel.updateFavourite(for: longPressedItemIndexPath)
                    showMenu = false
                }
                .presentationDetents([.height(100)])
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $showFiles) {
                AttachmentPicker(
                    pickerType: pickerType,
                    isPickerPresented: $showFiles,
                    filePath: $filePath,
                    fileId: $fileId,
                    fileName: $fileName,
                    fileExtension: $fileExt
                )
            }
            .sheet(isPresented: $showPhotoLibrary) {
                AttachmentPicker(
                    pickerType: pickerType,
                    isPickerPresented: $showPhotoLibrary,
                    filePath: $filePath,
                    fileId: $fileId,
                    fileName: $fileName,
                    fileExtension: $fileExt
                )
            }
            .onChange(of: filePath) {
                oldValue,
                newValue in
                self.viewModel.addFile(
                    fileId: fileId ?? UUID(),
                    fileName: fileName,
                    filePath: filePath,
                    fileType: fileExt
                )
                
            }
        .onAppear{
            if let directoryLocation = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
                print("Core Data Path : Documents Directory: \(directoryLocation) Application Support")
            }
            viewModel.getListData()
        }        
    }
    
    func updateShowOptionsSheetPresented(_ show : Bool){
        self.viewModel.isOptionsSheetPresented = show
    }
    
    func updateItems(_ items : [ListViewModel]){
        self.viewModel.listData = items
    }
}

#Preview {
    FoldersListView(viewModel: FoldersListViewModel())
}


