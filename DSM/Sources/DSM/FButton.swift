//
//  Untitled.swift
//  DSM
//
//  Created by Manikandan on 21/01/25.
//

import SwiftUI

public struct FButton: View {
    
    let name : String
    var onTapButton: () -> Void
    
    public init(name: String, onTapButton: @escaping () -> Void) {
        self.name = name
        self.onTapButton = onTapButton
    }
    
    public var body : some View{
        Button {
            self.onTapButton()
        } label: {
            RobotoText(name: name,size: 16)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                )
        }
    }
}

#Preview {
    FButton(name: "Click") {
        
    }
}
