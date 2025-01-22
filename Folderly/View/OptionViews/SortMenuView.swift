//
//  SortMenuView.swift
//  Folderly
//
//  Created by Manikandan on 20/01/25.
//
import SwiftUI

struct SortMenuView : View {
    
    let didTapSortByName : (() -> Void)?
    let didTapSortByDate : (() -> Void)?
        
    var body : some View{
        Menu {
            Button{
                self.didTapSortByName?()
            } label: {
                Label("Name", systemImage: "textformat")
            }
            
            Button{
                self.didTapSortByDate?()
            }label: {
                Label("Date", systemImage: "calendar")
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .resizable()
                .frame(width: 20, height: 17)
                .foregroundStyle(.blue)
        }
    }
}
