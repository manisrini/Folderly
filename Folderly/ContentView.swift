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
        FolderNavigationControllerWrapper()
            .edgesIgnoringSafeArea(.all)
            .onAppear{
                FontHelper.registerFonts()
            }
    }
}

#Preview {
    ContentView()
}


struct FolderNavigationControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewModel = FoldersListViewModel()
        let rootViewController = FoldersListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
