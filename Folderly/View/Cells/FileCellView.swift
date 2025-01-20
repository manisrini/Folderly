//
//  ListCellView.swift
//  Folderly
//
//  Created by Manikandan on 15/01/25.
//

import SwiftUI

enum FileType : String {
    case Folder
    case Pdf
    case Image
    case Video
}


struct FileCellView: View {
    
    let image : UIImage?
    let name : String
    let createdTime : String
    let didTapMenu : (()->())? = nil
    
    
    var body: some View {
        HStack(spacing : 20){
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
            
            VStack(alignment: .leading){
                Text(name)
                    .lineLimit(1)
                Text(createdTime)
                    .foregroundStyle(Color.black)
            }
                        
        }
        .padding()
    }
}

#Preview {
    FileCellView(image: nil, name: "Resume-dfsdf-sdf-sdfsdf-sdfsdfsdfsdf", createdTime: "Created on 12/12/2-24")
}
