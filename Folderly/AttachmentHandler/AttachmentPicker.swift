//
//  AttachmentPicker.swift
//  Folderly
//
//  Created by Manikandan on 15/01/25.
//

import SwiftUI
import UniformTypeIdentifiers

enum PickerType {
    case image
    case document
}

struct AttachmentPicker: UIViewControllerRepresentable {
    
    var pickerType : PickerType
    @Binding var isPickerPresented: Bool
    @Binding var filePath: String
    @Binding var fileId: UUID?
    @Binding var fileName: String
    @Binding var fileExtension: FileType

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate {
        var parent: AttachmentPicker

        init(parent: AttachmentPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                if let imageData = pickedImage.jpegData(compressionQuality: 1.0){
                    self.saveFile(data: imageData, fileExtension: "jpg")
                }
            }
            DispatchQueue.main.async { [self] in
                parent.isPickerPresented = false
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            DispatchQueue.main.async { [self] in
                parent.isPickerPresented = false
            }
        }
        
        // Document Picker Delegate
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let fileUrl = urls.first else { return }
            do {
                let fileData = try Data(contentsOf: fileUrl)
                let fileExtension = fileUrl.pathExtension
                saveFile(data: fileData, fileExtension: fileExtension)
            } catch {
                print("Error reading document: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.parent.isPickerPresented = false
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            DispatchQueue.main.async {
                self.parent.isPickerPresented = false
            }
        }

        
        private func saveFile(data: Data, fileExtension: String) {
            let fileManager = FileManager.default
            parent.fileExtension = FileType(rawValue: fileExtension) ?? .Image
            
            if let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                parent.fileId = UUID()
                if let fileId = parent.fileId {
                    parent.fileName = "\(fileId).\(fileExtension)"
                }
                let relativePath = parent.fileName
                let fileUrl = documentsDir.appendingPathComponent(relativePath)
                
                do {
                    try data.write(to: fileUrl)
                    parent.filePath = relativePath
                } catch {
                    print("Error saving file: \(error.localizedDescription)")
                }
            }
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        switch pickerType {
        case .image:
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = .photoLibrary
            picker.allowsEditing = false
            return picker

        case .document:
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.content, UTType.image, UTType.pdf], asCopy: true)
            picker.delegate = context.coordinator
            return picker

        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
}
