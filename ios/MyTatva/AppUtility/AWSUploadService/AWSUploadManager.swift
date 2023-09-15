//
//  AWSUploadConfigration.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 21/04/21.
//

import Foundation
import AWSCore
import AWSS3
import AVFoundation

final class AWSUploadManager: NSObject {
    
    // MARK: Shared Instance
    static let shared : AWSUploadManager = AWSUploadManager()
    
    // MARK: Class Properties
    private var completionHandler : AWSS3TransferUtilityUploadCompletionHandlerBlock?
    private var progressBlock : AWSS3TransferUtilityProgressBlock?
    
    private var multiPartProgressBlock: AWSS3TransferUtilityMultiPartProgressBlock?
    private var multipartCompletionHandler: AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock?
    
    typealias Handler = (Swift.Result<(String, Int?), Error>) -> Void
    typealias VideoThumbHandler = (Swift.Result<(String, String?, Int?), Error>) -> Void
    
    /// Configure AWS keys
    func configure() {
        let _ = AWSUploadConfigration.init()
        
        let credentialsProvider: AWSStaticCredentialsProvider = AWSStaticCredentialsProvider(accessKey: AWSUploadConfigration.accessKeyID!, secretKey: AWSUploadConfigration.secretKey!)
        
        let configuration: AWSServiceConfiguration = AWSServiceConfiguration(region: AWSUploadConfigration.regionType, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
}

// MARK: Image Uploader Function
extension AWSUploadManager {
    /// Uploads image data to the specified folder and have a optional param for remove old image from same folder.
    /// - Parameters:
    ///   - folder: Image upload folder.
    ///   - image: Image.
    ///   - deleteImageName: Delete image last path name. Default nil.
    ///   - showLoader: Flag for enable - disable loader. Default true.
    ///   - index: Upload proccess index. Default nil.
    ///   - mimeType: Image mime type. Default .jpeg
    ///   - compressionQuality: Image compression quality. Default 0.8.
    ///   - progressHandler: Upload image progress handler.
    ///   - completion: Completion block gives the success - failure block after upload image.
    ///                 Success block - (Uploaded image file path,  optional index)
    ///                 Failure block - Error
    func uploadImage(in folder: AWSBucketFolder,
                     image: UIImage,
                     deleteImageName: String? = nil,
                     showLoader: Bool = true,
                     index: Int? = nil,
                     mimeType: AWSFileMimeType = .jpeg,
                     compressionQuality: CGFloat = 0.8,
                     progressHandler: ((Progress) -> Void)? = nil,
                     completion: @escaping Handler) {
        
        // Show loader
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            if showLoader {
                ApiManager.shared.addLoader()
            }
        }
        
        // Generate key path/ folder path.
        let key = folder.path
        
        let remotePath = key + String.uniqueRandom() + mimeType.extesion
        
        let transferUtility = AWSS3TransferUtility.default()
        
        // Upload image progress block
        self.progressBlock = {(task, progress) in
            progressHandler?(progress)
            debugPrint(progress)
        }
        
        // Completion block for success/failure upload.
        self.completionHandler = { (task, error) -> Void in
            
            DispatchQueue.main.async(execute: {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                if showLoader {
                    ApiManager.shared.removeLoader()
                }
                
                if let error = error {
                    print("Failed with error: \(error)")
                    completion(.failure(error))
                    
                } else {
                    
                    // If delete image path found then delete image
                    if let deleteImageName = deleteImageName {
                        
                        self.deleteData(in: folder, with: deleteImageName) { (result) in
                            switch result {
                            case .success((_, let index)):
                                let uploadedImagePath = AWSUploadConfigration.basePath! + remotePath
                                print("🔲🔲🔲🔲🔲🔲🔲🔲 uploadedImagePath: \(JSON(uploadedImagePath)) 🔲🔲🔲🔲🔲🔲🔲🔲")
                                completion(.success((uploadedImagePath, index)))
                               
                            case .failure(let error):
                                print("error ==> ", error.localizedDescription)
                                completion(.failure(error))
                            }
                        }
                    } else {
                        let uploadedImagePath = AWSUploadConfigration.basePath! + remotePath
                        print("🔲🔲🔲🔲🔲🔲🔲🔲 uploadedImagePath: \(JSON(uploadedImagePath)) 🔲🔲🔲🔲🔲🔲🔲🔲")
                        completion(.success((uploadedImagePath.components(separatedBy: "/").last!, index)))
                    }
                }
            })
        }
        
        /// Upload image data.
        /// - Parameter data: Image data.
        func uploadImage(with data: Data) {
            let expression = AWSS3TransferUtilityUploadExpression()
            
            expression.setValue("public-read", forRequestHeader: "x-amz-acl")
            expression.setValue("\(image.size.height)", forRequestHeader: "x-amz-meta-height")
            expression.setValue("\(image.size.width)", forRequestHeader: "x-amz-meta-width")
            
            expression.progressBlock = progressBlock
            
            // Upload data request.
            transferUtility.uploadData(
                data,
                bucket : AWSUploadConfigration.bucket!,
                key: remotePath,
                contentType: mimeType.rawValue,
                expression: expression,
                completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
                    if let error = task.error {
                        print("Error: \(error.localizedDescription)")
                    }
                    
                    if let result = task.result {
                        print(result)
                    }
                    
                    return nil
                }
        }
        
        // Call upload image request.
        if let data = image.jpegData(compressionQuality: compressionQuality) {
            uploadImage(with: data)
        }
    }
}

// MARK: Video Uploader Function
extension AWSUploadManager {
    /// Uploads video data to the specified folder with optional thumb image.
    /// - Parameters:
    ///   - folder: Video upload folder.
    ///   - videoURL: Video file URL.
    ///   - withThumb: Flag for allow video to upload with thumb image. Default true.
    ///   - thumbFolder: Thumb image upload folder. Default nil.
    ///   - showLoader: Flag for enable - disable loader. Default true.
    ///   - mimeType: Video mime type. Default .mp4
    ///   - index: Upload proccess index. Default nil.
    ///   - progressHandler: Upload video progress handler.
    ///   - completion: Completion block gives the success - failure block after upload image.
    ///                 Success block - (Uploaded video file path, Uploaded optional thumb path,  optional index)
    ///                 Failure block - Error
    func uploadVideo(
        in folder: AWSBucketFolder,
        videoURL: URL,
        withThumb: Bool = true,
        thumbFolder: AWSBucketFolder?,
        showLoader: Bool = true,
        mimeType: AWSFileMimeType = .video,
        index: Int? = nil,
        progressHandler: ((Progress) -> Void)? = nil,
        completion: @escaping VideoThumbHandler) {
        
        /// Upload final video after converting.
        /// - Parameters:
        ///   - url: Video URL.
        ///   - isRemoveLoader: Flag for remove loader after completion.
        ///   - completion: Gives the success - failure block after upload.
        func uploadFinalVideo(with url: URL, isRemoveLoader: Bool, completion: @escaping Handler) {
            
            // Show loader.
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                if showLoader {
                    ApiManager.shared.addLoader()
                }
            }
            
            // Generate key path/ folder path.
            let key = folder.path
            let videoname = key + url.lastPathComponent
            
            // Upload video progress.
            self.multiPartProgressBlock = {(task, progress) in
                progressHandler?(progress)
                debugPrint(progress)
            }
            
            let expression = AWSS3TransferUtilityMultiPartUploadExpression()
            expression.setValue("public-read", forRequestHeader: "x-amz-acl")
            expression.progressBlock = self.multiPartProgressBlock
            
            // Completion handler for upload video.
            self.multipartCompletionHandler = { (task, error) -> Void in
                
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    if showLoader && isRemoveLoader {
                        ApiManager.shared.removeLoader()
                    }
                    
                    if let error = error {
                        debugPrint("Failed with error: \(error)")
                        completion(.failure(error))
                        
                    } else {
                        debugPrint("Success")
                        debugPrint(task.responds)
                        let finalURL = AWSUploadConfigration.basePath! + videoname
                        debugPrint("Success, VIDEO URL : ", finalURL)
                        completion(.success((finalURL, index)))
                    }
                })
            }
            
            // Create request for uploading video.
            AWSS3TransferUtility.default().uploadUsingMultiPart(fileURL: url, bucket: AWSUploadConfigration.bucket!, key: videoname, contentType: mimeType.rawValue, expression: expression, completionHandler: self.multipartCompletionHandler).continueWith() { (task) -> Any? in
                
                if let error = task.error {
                    debugPrint("Error: \(error.localizedDescription)")
                }
                
                if let _ = task.result {
                    debugPrint("Video Upload Starting!")
                }
                return nil
            }
        }
        
        // Convert video to .mp4 and change directory. This function also generate thumb image if enable thumb.
        self.pickVideoDataFromImagePicker(mediaURL: videoURL, withThumb: withThumb, mimeType: mimeType) { [weak self] (outputURL, thumbImage) in
            guard let outputURL = outputURL,
                  let self = self
            else {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    if showLoader {
                        ApiManager.shared.removeLoader()
                    }
                }
                return
            }
            
            // Check if thumb image found and enable thumb then upload video with thumb async. Else upload single video.
            if let thumbImage = thumbImage, let thumbFolder = thumbFolder, withThumb {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    if showLoader {
                        ApiManager.shared.addLoader()
                    }
                }
                
                let dispatchGroup = DispatchGroup()
                
                var finalError: Error? = nil
                var finalThumbPath: String = ""
                var finalVideoPath: String = ""
                var finalIndex: Int? = nil
                
                // Upload thumb
                dispatchGroup.enter()
                self.uploadImage(in: thumbFolder, image: thumbImage, showLoader: false) { (result) in
                    switch result {
                    case .success((let path, _)):
                        finalThumbPath = path
                        
                    case .failure(let error):
                        finalError = error
                    }
                    dispatchGroup.leave()
                }
                
                // Upload video
                dispatchGroup.enter()
                uploadFinalVideo(with: outputURL, isRemoveLoader: false) { (result) in
                    switch result {
                    case .success((let path, let index)):
                        finalVideoPath = path
                        finalIndex = index
                        
                    case .failure(let error):
                        finalError = error
                    }
                    
                    dispatchGroup.leave()
                }
                
                // Final notify
                dispatchGroup.notify(queue: .main) {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    
                    if showLoader {
                        ApiManager.shared.removeLoader()
                    }
                    
                    if let finalError = finalError {
                        completion(.failure(finalError))
                        return
                    }
                    
                    completion(.success((finalVideoPath, finalThumbPath, finalIndex)))
                }
                
            } else {
                uploadFinalVideo(with: outputURL, isRemoveLoader: true) { (result) in
                    switch result {
                    case .success((let path, let index)):
                        completion(.success((path, nil, index)))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

// MARK: Delete Data Function
extension AWSUploadManager {
    /// Delete any file data from S3 bucket. Also delete thumb image if avaible and set thumb folder path.
    /// - Parameters:
    ///   - folder: Delete file data folder name.
    ///   - name: Delete file data last path name.
    ///   - deleteThumbFolder: Thumb folder. Default nil.
    ///   - deleteThumbImage: Thumb file last path name. Default nil.
    ///   - showLoader: Flag for enable - disable loader. Default true.
    ///   - index: Upload proccess index. Default nil.
    ///   - completion: Completion block gives the success - failure block after upload image.
    ///                 Success block - (Deleted folder file path, optional index)
    ///                 Failure block - Error
    func deleteData(in folder: AWSBucketFolder,
                    with name: String,
                    deleteThumbFolder: AWSBucketFolder? = nil,
                    deleteThumbImage: String? = nil,
                    showLoader: Bool = true,
                    index: Int? = nil,
                    completion: @escaping Handler) {
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            if showLoader {
                ApiManager.shared.addLoader()
            }
        }
        
        let deleteObjectRequest = AWSS3DeleteObjectRequest()
        deleteObjectRequest?.bucket = AWSUploadConfigration.bucket!
        deleteObjectRequest?.key = folder.path + name
        
        guard let deleteRequest = deleteObjectRequest else {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if showLoader {
                    ApiManager.shared.removeLoader()
                }
            }
            
            return
        }
        
        AWSS3.default().deleteObject(deleteRequest).continueWith { (task) -> Any? in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if showLoader {
                    ApiManager.shared.removeLoader()
                }
                
                if let error = task.error {
                    debugPrint("Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                
                if let _ = task.result {
                    // If delete image path found then delete image
                    if let deleteThumbImage = deleteThumbImage, let deleteThumbFolder = deleteThumbFolder {
                        
                        self.deleteData(in: deleteThumbFolder, with: deleteThumbImage) { (result) in
                            switch result {
                            case .success((_, let index)):
                                let deleteImagePath = AWSUploadConfigration.basePath! + folder.path + name
                                completion(.success((deleteImagePath, index)))
                                
                            case .failure(let error):
                                print("error ==> ", error.localizedDescription)
                                completion(.failure(error))
                            }
                        }
                        
                    } else {
                        let deleteImagePath = AWSUploadConfigration.basePath! + folder.path + name
                        completion(.success((deleteImagePath, index)))
                    }
                }
            }
            return nil
        }
    }
}

// MARK: Video Helper Function
extension AWSUploadManager {
    /// This function encode video. Add video to document directory. Convert video to .mp4 type and set video quality.
    /// - Parameters:
    ///   - videoUrl: Input video URL.
    ///   - outputUrl: Output URL if any specific directory. Default nil.
    ///   - mimeType: Video mime type.
    ///   - resultClosure: Result closure will give final output converted video URL path.
    private func encodeVideo(videoUrl: URL, outputUrl: URL? = nil, mimeType: AWSFileMimeType, resultClosure: @escaping (URL?) -> Void ) {
        
        var finalOutputUrl: URL
        
        if let outputUrl = outputUrl {
            finalOutputUrl = outputUrl
            
        } else {
            var url = videoUrl
            url.deletePathExtension()
            url.appendPathExtension(mimeType.extesion)
            finalOutputUrl = url
        }
        
        if FileManager.default.fileExists(atPath: finalOutputUrl.path) {
            print("Converted file already exists \(finalOutputUrl.path)")
            resultClosure(finalOutputUrl)
            return
        }
        
        let asset = AVURLAsset(url: videoUrl)
        
        if let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) {
            exportSession.outputURL = finalOutputUrl
            exportSession.outputFileType = AVFileType.mp4
            let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
            let range = CMTimeRangeMake(start: start, duration: asset.duration)
            exportSession.timeRange = range
            exportSession.shouldOptimizeForNetworkUse = true
            
            exportSession.exportAsynchronously() {
                switch exportSession.status {
                case .failed:
                    print("Export failed: \(exportSession.error != nil ? exportSession.error!.localizedDescription : "No Error Info")")
                    resultClosure(nil)
                    
                case .cancelled:
                    print("Export canceled")
                    
                case .completed:
                    resultClosure(finalOutputUrl)
                    
                default:
                    break
                }
            }
        } else {
            resultClosure(nil)
        }
    }
    
    private func pickVideoDataFromImagePicker(mediaURL: URL, withThumb: Bool, mimeType: AWSFileMimeType, completion: @escaping (URL?, UIImage?) -> Void){
        let paths1 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory1 = paths1[0] as String
        let datapathT = documentsDirectory1.appending("/\(String.uniqueRandom())\(mimeType.extesion)")
        let tempURl : URL = URL(fileURLWithPath: datapathT)
        
        self.encodeVideo(videoUrl: mediaURL, outputUrl: tempURl, mimeType: mimeType) { (outputURL) in
            
            if !withThumb {
                completion(outputURL, nil)
                return
            }
            
            // Generate thumb image from video
            if let outputURL = outputURL {
                var snapImage = UIImage()
                
                do {
                    let asset = AVURLAsset(url: outputURL, options: nil)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                    snapImage = UIImage(cgImage: cgImage)
                    
                } catch {
                    debugPrint("public.movie ",error)
                }
                
                DispatchQueue.main.async {
                    completion(outputURL, snapImage)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
            }
        }
    }
}
