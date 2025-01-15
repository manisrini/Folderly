//
//  ContentView 2.swift
//  Folderly
//
//  Created by Manikandan on 14/01/25.
//

import SwiftUI

struct BottomSheetComponent: View {
    
    @Binding var showAddSheet : Bool
    @Binding var showOptionsSheet : Bool
    @Binding var showAttachmentSheet : Bool
    var didTapAddAttachment : (() -> ())?

    var body: some View {
        HStack{
            VStack(spacing : 15) {
                Button("Add Folder") {
                    print("ksdjbnfkj")
                    showOptionsSheet = false
                    showAddSheet = true
                }
                
                Button("Add Image") {
                    print("showksdjfgbk")
                    showOptionsSheet = false
                    showAttachmentSheet = true
                    self.didTapAddAttachment?()
                }
                
                Spacer()
            }
            .padding(.vertical,10)
            
            Spacer()
        }
        .padding(.horizontal,25)
     
    }
}

#Preview {
    BottomSheetComponent(showAddSheet: .constant(true), showOptionsSheet: .constant(true), showAttachmentSheet: .constant(true))
}
