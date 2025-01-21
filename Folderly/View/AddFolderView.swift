//
//  AddFolderView.swift
//  Folderly
//
//  Created by Manikandan on 14/01/25.
//

import SwiftUI
import DSM

struct AddFolderView: View {
    
    @Binding var textFieldStr : String
    @Binding var isAddSheetPresented : Bool
    @FocusState private var isTextFieldFocused: Bool
    var didClickAdd : (()->())?
    

    var body: some View {
        VStack(alignment : .leading,spacing: 15){
            Text("New Folder")
                .font(.headline)
            
            TextField("Name", text: $textFieldStr)
                .textFieldStyle(.roundedBorder)
                .focused($isTextFieldFocused)
            
            HStack{
                FButton(name: "Cancel") {
                    isAddSheetPresented = false
                }
                
                FButton(name: "Create") {
                    isAddSheetPresented = false
                    self.didClickAdd?()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextFieldFocused = true
            }
        }
    }
}

#Preview {
    AddFolderView(textFieldStr: .constant("Default"), isAddSheetPresented: .constant(true))
}
