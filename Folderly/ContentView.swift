//
//  ContentView.swift
//  Folderly
//
//  Created by Manikandan on 09/01/25.
//

import SwiftUI
import CoreData
import DSM

struct ContentView: View {
    
    var body: some View {
        FoldersListView(viewModel: FoldersListViewModel())
            .onAppear{
                FontHelper.registerFonts()
            }
    }
}




#Preview {
    ContentView()
}
