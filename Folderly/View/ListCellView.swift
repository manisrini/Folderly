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


struct ListCellView: View {
    
    let type : FileType = .Image
    let imageUrl : URL? = nil
    let name : String
    let createdTime : String
    let didTapMenu : (()->())?
    
    
    var body: some View {
        HStack(spacing : 20){
            
            if type == .Folder{
                Image(systemName: "folder.fill")
                    .resizable()
                    .frame(width: 25,height: 25)
            } else if type == .Image{
                if let url = self.imageUrl{
                    Image(systemName: "image.fill")
                        .resizable()
                        .frame(width: 25,height: 25)
                }
            }
            
            VStack(alignment: .leading){
                Text(name)
                Text(createdTime)
            }
            
            Spacer()
            
            Button {
                self.didTapMenu?()
            } label: {
                Image(systemName: "ellipsis")
            }
        }
        .padding()
    }
}

#Preview {
    ListCellView(name: "Resume.pdf", createdTime: "Created on 12/12/2-24", didTapMenu: {
        
    })
}
