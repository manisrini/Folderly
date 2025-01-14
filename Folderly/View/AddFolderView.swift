//
//  AddFolderView.swift
//  Folderly
//
//  Created by Manikandan on 14/01/25.
//

import SwiftUI

struct AddFolderView: View {
    
    @Binding var textFieldStr : String
    @Binding var isAddSheetPresented : Bool
    var didClickAdd : (()->())?

    var body: some View {
        VStack(alignment : .leading,spacing: 10){
            Text("New Folder")
                .font(.headline)
            
            TextField("Name", text: $textFieldStr)
            
            HStack{
                Button {
                    isAddSheetPresented = false
                } label: {
                    Group{
                        Text("Cancel")
                    }
                }
                
                Button {
                    isAddSheetPresented = false
                    self.didClickAdd?()
                } label: {
                    Text("Create")
                }
            }
        }
        .padding()
    }
}

#Preview {
    AddFolderView(textFieldStr: .constant("Default"), isAddSheetPresented: .constant(true))
}
