//
//  FilePreviewView.swift
//  Folderly
//
//  Created by Manikandan on 22/01/25.
//

import SwiftUI
import PDFKit
import DSM

struct FileItem: Identifiable {
    let id : UUID?
    let name: String
    let path: URL?
    let type: FileType
}

struct FilePreviewView: View {
    let file: FileItem
    
    var body: some View {
        VStack {
            RobotoText(
                name: file.name,
                style: .Bold,
                size: 20,
                lineLimit: 2
            )
            .padding(10)
            
            if file.type == .Image {
                if let filePath = file.path{
                    if let imageData = try? Data(contentsOf: filePath){
                        if let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(height: 300)
                                .padding(20)
                        } else {
                            Text("Image not found")
                        }
                    }
                }
            } else if file.type == .Pdf {
                if let filePath = file.path{
                    PDFKitView(fileUrl: filePath)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    FilePreviewView(file: .init(id: UUID(uuidString: "") ?? nil, name: "Test", path: nil, type: .Image))
}



struct PDFKitView: UIViewRepresentable {
    let fileUrl: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true 
        if let document = PDFDocument(url: fileUrl) {
            pdfView.document = document
        }
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
    }
}
