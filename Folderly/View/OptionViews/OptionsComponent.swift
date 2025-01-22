//
//  ContentView 2.swift
//  Folderly
//
//  Created by Manikandan on 14/01/25.
//

import SwiftUI
import DSM

struct OptionsComponent: View {
    
    @Binding var showAddSheet : Bool
    @Binding var showOptionsSheet : Bool
    @Binding var showAttachmentSheet : Bool
    var didTapAddAttachment : (() -> ())?

    var body: some View {
        HStack{
            HStack(spacing : 15) {
                FButton(name: "Add Folder") {
                    showOptionsSheet = false
                    showAddSheet = true
                }
                
                
                FButton(name: "Add File") {
                    showOptionsSheet = false
                    showAttachmentSheet = true
                    self.didTapAddAttachment?()
                }
            }
            .padding(.vertical,10)
            
            Spacer()
        }
        .padding(.horizontal,25)
     
    }
}

#Preview {
    OptionsComponent(showAddSheet: .constant(true), showOptionsSheet: .constant(true), showAttachmentSheet: .constant(true))
}
