//
//  CollectionViewRepresentable.swift
//  Folderly
//
//  Created by Manikandan on 18/01/25.
//
import SwiftUI
import SnapKit

struct CollectionViewRepresentable : UIViewRepresentable{

    @Binding var items: [ListViewModel]
    var onFolderTapped: (ListViewModel) -> Void

    func makeUIView(context: Context) -> UICollectionView {
        let layout = self.createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: FolderCellCollectionViewCell.nibName, bundle: nil),
                                forCellWithReuseIdentifier: FolderCellCollectionViewCell.nibName)
        collectionView.delegate = context.coordinator
        collectionView.dataSource = context.coordinator
        return collectionView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if context.coordinator.shouldUpdate(with: items) {
            context.coordinator.updateData(items)
            uiView.reloadData()
        }
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout{
        
        let groupSectionItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        groupSectionItem.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 12, bottom: 20, trailing: 0)
        let sectionGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(100)), subitems: [groupSectionItem])
        let section = NSCollectionLayoutSection(group: sectionGroup)
        

        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            return section
        }
        layout.configuration.interSectionSpacing = 5
        return layout
    }
}


class Coordinator : NSObject, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var parent : CollectionViewRepresentable
    private var items: [ListViewModel] = []

    
    init(_ parent : CollectionViewRepresentable){
        self.parent = parent
    }
    
    func shouldUpdate(with newItems: [ListViewModel]) -> Bool {
         
         // Check if data actually changed
         guard items.count != newItems.count || !items.elementsEqual(newItems, by: { old, new in
             return old.id == new.id 
         }) else {
             return false
         }
         return true
     }
    func updateData(_ items: [ListViewModel]) {
        self.items = items
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCellCollectionViewCell.nibName, for: indexPath) as? FolderCellCollectionViewCell{
            cell.backgroundColor = .green
                        
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }

            let item = items[indexPath.row]
            let name = item.name
            let createdDate = Utils.formatDate(date: item.creationDate ?? Date())
            
            if item.type == .Folder{
                let folderHostingView = UIHostingController(
                    rootView: FolderCellView(
                        name: name,
                        createdTime: createdDate
                    )
                )
                cell.contentView.addSubview(folderHostingView.view)
                
                folderHostingView.view.snp.makeConstraints { make in
                    make.left.equalTo(cell.contentView)
                    make.top.equalTo(cell.contentView)
                    make.bottom.equalTo(cell.contentView)
                    make.right.equalTo(cell.contentView).offset(20)
                }
            
            }else{
                
                let fileHostingView = UIHostingController(
                    rootView: FileCellView(
                        image: item.image,
                        name: name,
                        createdTime: createdDate
                    )
                )
                cell.contentView.addSubview(fileHostingView.view)
                
                fileHostingView.view.snp.makeConstraints { make in
                    make.left.equalTo(cell.contentView)
                    make.top.equalTo(cell.contentView)
                    make.bottom.equalTo(cell.contentView)
                    make.right.equalTo(cell.contentView)
                }
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if item.type == .Folder {
            parent.onFolderTapped(item)  // Trigger the navigation action
        }
    }

    
}
