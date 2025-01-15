//
//  AttachmentHandler.swift
//  Folderly
//
//  Created by Manikandan on 15/01/25.
//

import Foundation
import UIKit
import Photos

public enum AttachmentType: String{
    case camera, video, photoLibrary, file
    
    var formatTitle: String {
        switch self {
        case .camera:
            return "Image"
        case .video:
            return "Video"
        case .photoLibrary:
            return "Image"
        case .file:
            return "File"
        }
    }
}

class AttachmentHandler : NSObject {
    
    // MARK: - Variables
    public static let shared = AttachmentHandler()
    fileprivate var currentVC: UIViewController?
    fileprivate var isSaveLocal: Bool = false
    fileprivate var isVideoEnabled: Bool = false
    // MARK: - CallBack properties
    public var imagePickedBlock: ((UIImage, URL?) -> Void)?
    public var videoPickedBlock: ((URL) -> Void)?
    public var filePickedBlock: (([URL]) -> Void)?
    public var localDirectoryPathBlock: ((Result<URL,Error>) -> Void)?

    public func showAttachmentActionSheet(currentVC: UIViewController, isSaveLocal: Bool, isPhotosEnabled: Bool = true, isFileEnabled: Bool = false, isVideoEnabled: Bool = false) {
        self.currentVC = currentVC
        self.isSaveLocal = isSaveLocal
        self.isVideoEnabled = isVideoEnabled
        
        var actionSheet = UIAlertController(title: AttachmentHandlerConstants.actionFileTypeHeading, message: AttachmentHandlerConstants.actionFileTypeDescription, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: AttachmentHandlerConstants.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera)
        }))
        
        // Photo enable check
        if isPhotosEnabled {
            actionSheet.addAction(UIAlertAction(title: AttachmentHandlerConstants.photoLibrary, style: .default, handler: { (action) -> Void in
                self.authorisationStatus(attachmentTypeEnum: .photoLibrary)
            }))
        }
        
        // File enable check
        if isFileEnabled {
            actionSheet.addAction(UIAlertAction(title: AttachmentHandlerConstants.file, style: .default, handler: { (action) -> Void in
                DispatchQueue.main.async {
//                    self.accessFilesApp()
                }
            }))
        }
        
//        actionSheet = setPropForUIAlertController(alert: actionSheet, view: self.currentVC?.view)

        actionSheet.addAction(UIAlertAction(title: AttachmentHandlerConstants.cancelBtnTitle, style: .cancel, handler: nil))
        
        self.currentVC?.present(actionSheet, animated: true, completion: nil)
    }
    
    
    public func authorisationStatus(attachmentTypeEnum: AttachmentType) {
        if attachmentTypeEnum ==  AttachmentType.camera {
            // Checking Camera access
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status{
            case .authorized: // The user has previously granted access to the camera.
                DispatchQueue.main.async {
                    self.openCamera()
                }
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        DispatchQueue.main.async {
                            self.openCamera()
                        }
                    }
                }
            case .denied, .restricted:
                print(AttachmentHandlerConstants.alertForCameraAccessMessage)
                self.showAlert(title: "", message: AttachmentHandlerConstants.alertForCameraAccessMessage)
            default:
                break
            }
        } else if attachmentTypeEnum == AttachmentType.photoLibrary {
            // Checking Photos access
            let status = PHPhotoLibrary.authorizationStatus()
            switch status{
            case .authorized:
                DispatchQueue.main.async {
                    self.photoLibrary()
                }
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized {
                        // photo library access given
                        DispatchQueue.main.async {
                            self.photoLibrary()
                        }
                    }
                })
            case .denied, .restricted:
                print(AttachmentHandlerConstants.alertForPhotoLibraryMessage)
                self.showAlert(title: "", message: AttachmentHandlerConstants.alertForPhotoLibraryMessage)
            default:
                break
            }
        } else if attachmentTypeEnum == AttachmentType.video {
            // Checking Video library access
            let status = PHPhotoLibrary.authorizationStatus()
            switch status{
            case .authorized:
                DispatchQueue.main.async {
//                    self.videoLibrary()
                }
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized {
                        // video library access given
                        DispatchQueue.main.async {
//                            self.videoLibrary()
                        }
                    }
                })
            case .denied, .restricted:
                print(AttachmentHandlerConstants.alertForVideoLibraryMessage)
                self.showAlert(title: "", message: AttachmentHandlerConstants.alertForVideoLibraryMessage)
            default:
                break
            }
        }
    }
    
    
    public func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { uiAlertAction in
            // Redirect to particular APP Setting.
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        currentVC?.present(alert, animated: true, completion: nil)
    }
    
    
    //    Open Camera
    public func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = true
            myPickerController.modalPresentationStyle = .overFullScreen
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    //    Open Photos
    public func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = true
            if isVideoEnabled {
                myPickerController.mediaTypes = [UTType.image.description, UTType.movie.description, UTType.video.description]
            }
            myPickerController.modalPresentationStyle = .overFullScreen
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
}

extension AttachmentHandler: UIDocumentPickerDelegate {
    
    //    Method to handle cancel action.
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // Handle the selected file(s) here
        self.filePickedBlock?(urls)
        if isSaveLocal {
//            FCDDirectoryHandler.shared.saveAttachmentInDirectory(attachmentType: .file, selectedFile: nil, fileUrl: urls.first, fileNameStr: "", isFromPhotos: false) { resultObj in
//                self.localDirectoryPathBlock?(resultObj)
//            }
        }
    }
}

extension AttachmentHandler: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if mediaType  == "public.image" {
                //                image selected block
                if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let imageData = image.jpegData(compressionQuality: 0.5), let compressedImage = UIImage(data: imageData)  {
                    if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                        // From photos
                        if isSaveLocal {
                            //                            self.saveAttachmentInDirectory(selectedFile: compressedImage, fileUrl: imageUrl, fileNameStr: "", isFromPhotos: true)
//                            FCDDirectoryHandler.shared.saveAttachmentInDirectory(attachmentType: .photoLibrary, selectedFile: compressedImage, fileUrl: imageUrl, fileNameStr: "", isFromPhotos: true) { resultObj in
//                                self.localDirectoryPathBlock?(resultObj)
//                            }
                        } else {
                            self.imagePickedBlock?(compressedImage, imageUrl)
                        }
                    } else {
                        // From Camera
                        if isSaveLocal {
                            //                            self.saveAttachmentInDirectory(selectedFile: compressedImage, fileUrl: nil, fileNameStr: "", isFromPhotos: true)
//                            FCDDirectoryHandler.shared.saveAttachmentInDirectory(attachmentType: .camera, selectedFile: compressedImage, fileUrl: nil, fileNameStr: "", isFromPhotos: true) { resultObj in
//                                self.localDirectoryPathBlock?(resultObj)
//                            }
                        } else {
                            self.imagePickedBlock?(compressedImage, nil)
                        }
                    }
                } else {
                    print("Something went wrong in fetch image")
                }
            }  else if mediaType == "public.movie" {
                //                video selected block
                if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    print("videourl: ", videoUrl)
                    //trying compression of video
                    let data = NSData(contentsOf: videoUrl)!
                    print("File size before compression: \(Double(data.length / 1048576)) mb")
                    if isSaveLocal {
//                        FCDDirectoryHandler.shared.saveAttachmentInDirectory(attachmentType: .video, selectedFile: nil, fileUrl: videoUrl, fileNameStr: "", isFromPhotos: false) { resultObj in
//                            self.localDirectoryPathBlock?(resultObj)
//                        }
                    }
                    self.videoPickedBlock?(videoUrl)
                }
                else{
                    print("Something went wrong in fetch video")
                }
            }
        }
        currentVC?.dismiss(animated: true, completion: nil)
    }
}

struct AttachmentHandlerConstants {
    static let actionFileTypeHeading = "Add a File"
    static let actionFileTypeDescription = "Choose a file type to add"
    static let camera = "Camera"
    static let photoLibrary = "Photo Library"
    static let image = "Image"
    static let video = "Video"
    static let file = "File"
    static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
    static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
    static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
    static let settingsBtnTitle = "Settings"
    static let cancelBtnTitle = "Cancel"
}

