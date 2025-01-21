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
    
    
    @State private var isImagePickerPresented = false
    @State private var filePath: String = ""
    @State private var fileId: UUID?
    @State private var fileName: String = ""
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    
    @State private var textFieldStr : String = ""
    
    @ObservedObject var viewModel : FoldersListViewModel
    @State private var doPresentView: Bool = false
    
    @State private var selectedFolder: ListViewModel?

    private let viewTag: String
    
    @State private var showMenu = false
    @State private var longPressedItemIndexPath: IndexPath = IndexPath(row: 0, section: 0)

    init(viewModel : FoldersListViewModel){
        self.viewModel = viewModel
        self.viewTag = UUID().uuidString
    }
    
    var body: some View {
        NavigationStack {
            CollectionViewRepresentable(
                items: $viewModel.listData,
                onFolderTapped: { folder in
                    if !doPresentView {
                        selectedFolder = folder
                        doPresentView = true
                    }
                },
                onLongPress: { indexPath in
                    print(indexPath)
                    if indexPath.row < viewModel.listData.count {
                        DispatchQueue.main.async {
                            showMenu = true
                            longPressedItemIndexPath = indexPath

                        }
                    }
                }
            )
            .navigationDestination(isPresented: $doPresentView){
                if let folder = selectedFolder, folder.id?.uuidString != viewTag{
                    FoldersListView(viewModel: FoldersListViewModel(folder: folder))
                        .tag(folder.id?.uuidString)
                }
            }
            .toolbarRole(.editor)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(self.viewModel.getNavBarTitle())
                        .font(.title)
                }
                ToolbarItemGroup{

                    SortMenuView(items: $viewModel.listData)
                    
                    Button {
                        isOptionsSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.blue)
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
                    showPhotoLibrary = true
                } label: {
                    Text("Photos Library")
                }
                
                Button("Cancel", role: .cancel) {}
            }
            .sheet(isPresented: $showMenu){
                let _ = print(showMenu)
                let _ = print(longPressedItemIndexPath)

                LongPressOptionsView(item: self.viewModel.listData[longPressedItemIndexPath.row]) {
                    self.viewModel.updateFavourite(for: longPressedItemIndexPath)
                    showMenu = false
                }
                .presentationDetents([.height(100)])
            }

            .buttonStyle(.plain)
//            .sheet(isPresented: $showCamera) {
//                ImagePicker(
//                    sourceType: .camera,
//                    isImagePickerPresented: $showCamera,
//                    filePath: $filePath,
//                    fileId: $fileId,
//                    fileName: $fileName
//                )
//            }
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
                print("Core Data Path : Documents Directory: \(directoryLocation) Application Support")
            }
            viewModel.getListData()
        }        
    }
}

#Preview {
    FoldersListView(viewModel: FoldersListViewModel())
}
