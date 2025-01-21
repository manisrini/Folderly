//
//  LongPressOptionsView.swift
//  Folderly
//
//  Created by Manikandan on 21/01/25.
//

import SwiftUI

struct LongPressOptionsView: View {
    
    let item : ListViewModel?
    var onTapAddToFav : () -> Void
    
    var body: some View {
        Button {
            self.onTapAddToFav()
        } label: {
            Text(item?.isFavourite ?? false ? "Remove from Favorites" : "Add to Favorites")
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                )
        }
        .fixedSize()
    }
}

#Preview {
    LongPressOptionsView(item: .init(id: UUID(uuidString: "1"), type: .Folder, name: "Test", creationDate: Date(), isFavourite: false)) {
        
    }
}
