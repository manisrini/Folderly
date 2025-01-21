//
//  SwiftUIView.swift
//  DSM
//
//  Created by Manikandan on 21/01/25.
//

import SwiftUI

public struct RobotoText: View {
    
    let name : String
    let style : Roboto
    let size : CGFloat
    
    public init(name: String,style : Roboto = .Regular, size : CGFloat = 14){
        self.name = name
        self.style = style
        self.size = size
    }
    
    public var body: some View {
        Text(name)
            .lineLimit(1)
            .customFontStyle(.Roboto(style, size))
    }
}

#Preview {
    RobotoText(name: "Mani")
}
