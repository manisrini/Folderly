//
//  ListCellView.swift
//  Folderly
//
//  Created by Manikandan on 15/01/25.
//

import SwiftUI
import DSM

enum FileType : String {
    case Folder
    case Pdf = "pdf"
    case Image = "jpg"
    case Video
}


struct FileCellView: View {
    
    let image : UIImage?
    let name : String
    let createdTime : String
    let fileType : FileType
    let didTapMenu : (()->())? = nil
    
    init(image: UIImage?, name: String, createdTime: String,fileType : FileType = .Pdf) {
        self.image = image
        self.name = name
        self.createdTime = createdTime
        self.fileType = fileType
    }
    
    
    var body: some View {
        HStack(spacing : 20){
            if fileType == .Image{
                if let _image = self.image{
                    Image(uiImage: _image)
                        .resizable()
                        .frame(width: 40,height: 40)
                        .clipShape(Circle())
                }else{
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundStyle(.gray)
                        .frame(width: 30,height: 30)
                }
            } else if fileType == .Pdf{
                Image(systemName: "doc.richtext")
                    .resizable()
                    .frame(width: 25,height: 25)
            }
            
            VStack(alignment: .leading){
                RobotoText(name: name,style: .Medium,size: 18)
                RobotoText(name: createdTime,style: .Regular,size: 16)
            }
                        
        }
        .padding()
    }
}

#Preview {
    FileCellView(image: nil, name: "Resume-dfsdf-sdf-sdfsdf-sdfsdfsdfsdf", createdTime: "Created on 12/12/2-24")
}
