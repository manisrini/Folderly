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
    var onFileTapped: (ListViewModel) -> Void
    var onLongPress: (IndexPath) -> Void

    func makeUIView(context: Context) -> UICollectionView {
        let layout = self.createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: FolderCellCollectionViewCell.nibName, bundle: nil),
                                forCellWithReuseIdentifier: FolderCellCollectionViewCell.nibName)
        collectionView.delegate = context.coordinator
        collectionView.dataSource = context.coordinator
        collectionView.backgroundColor = Utils.hexStringToUIColor(hex: "CACACA")
        
        context.coordinator.setCollectionView(collectionView)
        
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(longPressGesture)

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
        groupSectionItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let sectionGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), subitems: [groupSectionItem])
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
    private weak var collectionView : UICollectionView?
    
    init(_ parent : CollectionViewRepresentable){
        self.parent = parent
    }
    
    func setCollectionView(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func shouldUpdate(with newItems: [ListViewModel]) -> Bool {
         
         guard items.count != newItems.count || !items.elementsEqual(newItems, by: { old, new in
             return old.id == new.id  && old.isFavourite == new.isFavourite
         }) else {
             return false
         }
         return true
     }
    
    func updateData(_ items: [ListViewModel]) {
        self.items = items
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
           guard gesture.state == .began,
                 let collectionView = collectionView else { return }
           
           let point = gesture.location(in: collectionView)
           
           if let indexPath = collectionView.indexPathForItem(at: point) {
               let item = items[indexPath.row]
               if item.type == .Folder{
                   parent.onLongPress(indexPath)
               }
           }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCellCollectionViewCell.nibName, for: indexPath) as? FolderCellCollectionViewCell{

            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            let item = items[indexPath.row]
            let name = item.name
            let createdDate = Utils.formatDate(date: item.creationDate ?? Date())
            
            if item.type == .Folder{
                let folderHostingView = UIHostingController(
                    rootView: FolderCellView(
                        name: name,
                        createdTime: createdDate,
                        isFavourite: item.isFavourite
                    )
                )
                cell.contentView.addSubview(folderHostingView.view)
                
                folderHostingView.view.snp.makeConstraints { make in
                    make.left.equalTo(cell.contentView)
                    make.top.equalTo(cell.contentView)
                    make.bottom.equalTo(cell.contentView)
                    make.right.equalTo(cell.contentView)
                }
            
            }else{
                
                let fileHostingView = UIHostingController(
                    rootView: FileCellView(
                        filePath: item.filePath,
                        name: name,
                        createdTime: createdDate,
                        fileType: item.type
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
            parent.onFolderTapped(item) 
        }else{
            parent.onFileTapped(item)
        }
    }

    
}
