//
//  ContentView.swift
//  Folderly
//
//  Created by Manikandan on 09/01/25.
//

import SwiftUI
import CoreData


struct ContentView: View {
    
    var body: some View {
        FoldersListView(viewModel: FoldersListViewModel())
    }
}




#Preview {
    ContentView()
}
