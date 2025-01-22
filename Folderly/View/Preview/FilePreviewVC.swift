//
//  FilePreviewVC.swift
//  Folderly
//
//  Created by Manikandan on 22/01/25.
//

import UIKit
import SwiftUI

class FilePreviewVC : UIViewController{
    
    let fileItem : FileItem
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(file: FileItem) {
        self.fileItem = file
        super.init(nibName: nil, bundle: nil)
        self.onLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func onLoad(){
        let filePreview = FilePreviewView(file: fileItem)
        let hostingController = UIHostingController(rootView: filePreview)
        self.view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
