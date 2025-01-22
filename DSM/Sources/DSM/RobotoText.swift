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
    let lineLimit: Int
    
    public init(name: String,style : Roboto = .Regular, size : CGFloat = 14, lineLimit: Int = 1){
        self.name = name
        self.style = style
        self.size = size
        self.lineLimit = lineLimit
    }
    
    public var body: some View {
        Text(name)
            .lineLimit(lineLimit)
            .customFontStyle(.Roboto(style, size))
    }
}

#Preview {
    RobotoText(name: "Mani")
}
