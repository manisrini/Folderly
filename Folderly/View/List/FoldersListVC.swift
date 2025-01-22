//
//  FoldersListVc.swift
//  Folderly
//
//  Created by Manikandan on 22/01/25.
//

import UIKit
import SwiftUI
import DSM

class FoldersListViewController: UIViewController {
    
    private var viewModel: FoldersListViewModel
    private var hostingController: UIHostingController<FoldersListView>?
    private var foldersListView : FoldersListView?
    
    init(viewModel: FoldersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHostingController()
        setupNavigationBar()
    }
    
    private func setupHostingController() {
        let foldersListView = FoldersListView(viewModel: viewModel,onFolderTap: { [weak self] selectedFolder in
            self?.navigateToFolder(with: FoldersListViewModel(folder: selectedFolder))
        },onFileTap: { [weak self] selectedFile in
            self?.navigateToPreview(with: selectedFile)
        })
        
        self.foldersListView = foldersListView
        hostingController = UIHostingController(rootView: foldersListView)
        
        guard let hostingController = hostingController else { return }
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupNavigationBar() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.getNavBarTitle()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        self.navigationItem.titleView = label

        
        let sortButtonView = SortMenuView(didTapSortByName: { [weak self] in
            self?.viewModel.sortByName()
        }, didTapSortByDate: { [weak self] in
            self?.viewModel.sortByDate()
        })
        let hostingView = UIHostingController(rootView: sortButtonView)
        

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)),
            UIBarButtonItem(customView: hostingView.view),
        ]
    }
    
    @objc private func addButtonTapped() {
        self.foldersListView?.updateShowOptionsSheetPresented(true)
    }
    
    func navigateToFolder(with viewModel: FoldersListViewModel) {
        let folderViewController = FoldersListViewController(viewModel: viewModel)
        navigationController?.pushViewController(folderViewController, animated: true)
    }
    
    func navigateToPreview(with viewModel: ListViewModel) {
        let filePreviewVC = FilePreviewVC(
            file: .init(
                id: viewModel.id,
                name: viewModel.name,
                path: viewModel.filePath,
                type: viewModel.type
            )
        )
        navigationController?.pushViewController(filePreviewVC, animated: true)
    }
    
}
