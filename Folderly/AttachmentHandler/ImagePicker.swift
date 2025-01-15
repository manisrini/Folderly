//
//  AttachmentOptionDialogue.swift
//  Folderly
//
//  Created by Manikandan on 15/01/25.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var isImagePickerPresented: Bool
    @Binding var filePath: URL?
    @Binding var fileId: UUID?
    @Binding var fileName: String

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                if let imageData = pickedImage.jpegData(compressionQuality: 1.0){
                    let fileManager = FileManager.default
                    
                    if let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
                        parent.fileId = UUID()
                        if let fileId = parent.fileId{
                            parent.fileName = "\(fileId).jpg"
                        }
                        let fileUrl = documentsDir.appendingPathComponent(parent.fileName)
                        
                        do{
                            try imageData.write(to: fileUrl)
                            parent.filePath = fileUrl
                        }catch {
                            print("Error saving image: \(error.localizedDescription)")
                        }
                    }
                }
            }
            DispatchQueue.main.async { [self] in
                parent.isImagePickerPresented = false
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            DispatchQueue.main.async { [self] in
                parent.isImagePickerPresented = false
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

