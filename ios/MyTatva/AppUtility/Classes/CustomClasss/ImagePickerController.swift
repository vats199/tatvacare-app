//
//  ImagePickerController.swift
//  GolfGrub
//
//  Created by KISHAN_RAJA on 18/12/20.
//

import UIKit
import AVFoundation
import Photos

class ImagePickerController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let pickerController: UIImagePickerController?
    private let onImagePicked: (UIImage) -> Void
    let selectImageOption = UIAlertController(title: nil, message: AppMessages.imagepickerHeading.localized, preferredStyle: .actionSheet)
    
    //init
    public init(isAllowEditing: Bool = true, onImagePicked: @escaping (UIImage) -> Void) {
        self.pickerController = UIImagePickerController()
        self.onImagePicked = onImagePicked
        super.init()
        
        self.pickerController?.delegate = self
        self.pickerController?.allowsEditing = isAllowEditing
        //        self.pickerController.mediaTypes = ["public.image"]
    }
    
    //present
    public func present() {
        
        selectImageOption.addAction(UIAlertAction(title: AppMessages.imagepickerGallery.localized, style: .default, handler: { (selectImage) in
            //            guard let self = self else { return }
            self.authorizeToAlbum {  (isGiven) in
                if isGiven {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        self.pickerController?.modalPresentationStyle = .popover
                        self.pickerController?.sourceType = .photoLibrary
                        self.pickerController?.delegate = self
                        //               self.presentationController?.present(self.pickerController, animated: true, completion: nil)
                        if let pickerController = self.pickerController {
                            UIApplication.topViewController()?.present(pickerController, animated: true, completion: {
                                
                            })
                        }
                    }
                }
            }
        }))
        
        selectImageOption.addAction(UIAlertAction(title: AppMessages.imagepickerCamera.localized, style: .default, handler: {  (selectCamera) in
            //            guard let self = self else { return }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.isGiveCameraPermissionAlert({ (isGiven) in
                    if isGiven {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.pickerController?.sourceType = .camera
                            if let pickerController = self.pickerController {
                                UIApplication.topViewController()?.present(pickerController, animated: true, completion: nil)
                            }
                        }
                    }
                })
                
            } else {
                Alert.shared.showSnackBar(AppMessages.imagepickerCameraError.localized, isError: true)
            }
        }))
        
        selectImageOption.addAction(UIAlertAction(title: AppMessages.cancel.localized, style: .cancel, handler: { [weak self] (selectCamera) in
            guard let self = self else { return }
            self.pickerController?.dismiss(animated: true, completion: nil)
        }))
        
        UIApplication.topViewController()?.present(selectImageOption, animated: true)
    }
    
    //permission alert
    private func isGiveCameraPermissionAlert(_ completion: @escaping ((Bool) -> Void)) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
            completion(true)
            
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    completion(true)
                    
                } else {
                    completion(false)
                    print("Disable")
                    
                    var errorMessage : String = ""
                    errorMessage = "Enable \(Bundle.appName()) to access your camera roll to upload your photos and save ones you have taken with the app."
                    
                    
                    let permissionAlert = UIAlertController(title: "\(Bundle.appName()) would like to access your camera?" , message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                    
                    permissionAlert.addAction(UIAlertAction(title: AppMessages.ok, style: .default, handler: { (action: UIAlertAction!) in
                        
                        if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        }
                        
                    }))
                    
                    permissionAlert.addAction(UIAlertAction(title: AppMessages.dontAllow, style: .cancel, handler: { (action: UIAlertAction!) in
                        
                    }))
                    
                    DispatchQueue.main.async {
                        UIApplication.topViewController()?.present(permissionAlert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    private func authorizeToAlbum(completion:@escaping (Bool)->Void) {
        
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            NSLog("Will request authorization")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    DispatchQueue.main.async {
                        print("==================> authorized")
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        print("==================> false")
                        completion(false)
                        var errorMessage : String = ""
                        errorMessage = "Enable \(Bundle.appName()) to access your photos, It will help you to quickly select images from the photo gallery to edit those images."
                        
                        let permissionAlert = UIAlertController(title: "\(Bundle.appName()) would like to access your photos?" , message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                        
                        permissionAlert.addAction(UIAlertAction(title: AppMessages.ok, style: .default, handler: { (action: UIAlertAction!) in
                            
                            if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                            }
                            
                        }))
                        
                        permissionAlert.addAction(UIAlertAction(title: AppMessages.dontAllow, style: .cancel, handler: { (action: UIAlertAction!) in
                            
                        }))
                        
                        DispatchQueue.main.async {
                            UIApplication.topViewController()?.present(permissionAlert, animated: true, completion: nil)
                        }
                    }
                }
            })
            
        } else {
            DispatchQueue.main.async(execute: {
                print("==================> true")
                completion(true)
            })
        }
    }
}

extension ImagePickerController {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {
            let imgData = NSData(data: image.jpegData(compressionQuality: 0.7)!)
            let imageSize: Double = Double(imgData.count) / 1000.0
            print("Actual size of image in KB:", Double(imageSize) )

            GFunction.shared.allowedFileSize(sizeInKb: Int(imageSize)) { isAllowed in
                if isAllowed{
                    onImagePicked(image)
                }
            }
            
            
        } else if let image = info[.originalImage] as? UIImage {
            let imgData = NSData(data: image.jpegData(compressionQuality: 0.7)!)
            let imageSize: Double = Double(imgData.count) / 1000.0
            print("Actual size of image in KB:", Double(imageSize))
            
            GFunction.shared.allowedFileSize(sizeInKb: Int(imageSize)) { isAllowed in
                if isAllowed{
                    onImagePicked(image)
                }
            }
        }
    }
}
