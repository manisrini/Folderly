//
//  FolderCell.swift
//  Folderly
//
//  Created by Manikandan on 16/01/25.
//
import SwiftUI

struct FolderCellView: View {
    
    let name : String
    let createdTime : String
    let didTapMenu : (()->())? = nil
    
    
    var body: some View {
        HStack(spacing : 20){
            
            Image(systemName: "folder.fill")
                .resizable()
                .frame(width: 25,height: 25)
            
            VStack(alignment: .leading){
                Text(name)
                    .lineLimit(1)
                Text(createdTime)
                    .foregroundStyle(Color.black)
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
    FolderCellView(name: "Resume-dfsdf-sdf-sdfsdf-sdfsdfsdfsdf", createdTime: "Created on 12/12/2-24") 
}
