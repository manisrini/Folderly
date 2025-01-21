//
//  LongPressOptionsView.swift
//  Folderly
//
//  Created by Manikandan on 21/01/25.
//

import SwiftUI
import DSM

struct LongPressOptionsView: View {
    
    let item : ListViewModel?
    var onTapAddToFav : () -> Void
    
    var body: some View {
        
        FButton(
            name: item?.isFavourite ?? false ? "Remove from Favorites" : "Add to Favorites") {
                self.onTapAddToFav()
            }
    }
}

#Preview {
    LongPressOptionsView(item: .init(id: UUID(uuidString: "1"), type: .Folder, name: "Test", creationDate: Date(), isFavourite: false)) {
        
    }
}
