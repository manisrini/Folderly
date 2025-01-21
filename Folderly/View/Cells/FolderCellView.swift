//
//  FolderCell.swift
//  Folderly
//
//  Created by Manikandan on 16/01/25.
//
import SwiftUI
import DSM

struct FolderCellView: View {
    
    let name : String
    let createdTime : String
    let isFavourite : Bool
    let didTapMenu : (()->())? = nil
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(isFavourite ? .green : .white)
            .frame(height: 80)
            .overlay {
                HStack(spacing : 20){
                    
                    Image(systemName: "folder.fill")
                        .resizable()
                        .frame(width: 25,height: 25)
                    
                    VStack(alignment: .leading,spacing : 4){
                        RobotoText(name: name,style: .Medium,size: 18)
                        RobotoText(name: createdTime,style: .Regular,size: 16)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 10,height: 15)
                        .padding(.trailing,5)

                }
                .padding()
            }
    }
}

#Preview {
    FolderCellView(
        name: "Resume-dfsdf-sdf-sdfsdf-sdfsdfsdfsdf",
        createdTime: "Created on 12/12/2-24",
        isFavourite: true
    ) 
}
