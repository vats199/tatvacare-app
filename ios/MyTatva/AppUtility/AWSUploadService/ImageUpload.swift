//
//  ImageUpload.swift
//  Smyllo
//
//  Created by on 16/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

//Storage name : developerstemp
//Access Key :
//yOLHVXsNedswUpeXDAEAsido9gzPuHVYAXm5Ss6sLeo2M7eOZPEXxd+jyBAU7K5AYhbSrK+MJ2JyLdu8ym9r9g==
//Container name : mytatva-dev
//Portal :
//https://portal.azure.com/#@HYPERLINKINFOSYSTEMPRIVATEL.onmicrosoft.com/resource/subscriptions/17b483cb-a5d8-4663-9658-7893b4d58c0e/resourcegroups/mytatva-common/providers/Microsoft.Storage/storageAccounts/developerstemp/overview

/*
 Production
 
 AZURE_CONTAINER_ACCESS_KEYS = 'o0L6kqnwjBW96Ttj75eHWfJAWABK/1cUuFD658PDvtVbOuxWufQpvprhe7lMHsEsd1nE8SX3tJ5m+xg6VDcJeQ=='
 AZURE_STORAGE = 'aztatvaprodstorage'
 AZURE_CONTAINER = 'aztatva-prod-storage-container'
 */


// //Production
//class AzureCredentials  {
//    static var kAccessSecretKey = "o0L6kqnwjBW96Ttj75eHWfJAWABK/1cUuFD658PDvtVbOuxWufQpvprhe7lMHsEsd1nE8SX3tJ5m+xg6VDcJeQ=="
//    static var kAccountName = "aztatvaprodstorage"
//
//    init(kAccessSecretKey: String,
//         kAccountName: String){
//
//        AzureCredentials.kAccessSecretKey   = kAccessSecretKey
//        AzureCredentials.kAccountName       = kAccountName
//    }
//}

//class BlobContainer  {
//    static var kAppContainer = "aztatva-prod-storage-container"
//
//    init(kAppContainer: String){
//
//        BlobContainer.kAppContainer  = kAppContainer
//    }
//}


//Development
class AzureCredentials  {
    static var kAccessSecretKey = ""//"uV5ueScj6CaWDTm6TOF8JBYf2SrqhqN8yXMfNveXLH998gcLIz5pUkZkkjktZSDELOrLUhnTxuW2cw4OhTFFfg=="
    static var kAccountName = ""//"mytatvahldevstorage"
    
    init(kAccessSecretKey: String,
         kAccountName: String){
        
        AzureCredentials.kAccessSecretKey   = kAccessSecretKey
        AzureCredentials.kAccountName       = kAccountName
    }
}

class BlobContainer  {
    static var kAppContainer = ""//"mytatvahl-dev-storage-container"
    
    init(kAppContainer: String){
        
        BlobContainer.kAppContainer  = kAppContainer
    }
}


enum PrefixContainer: String {
    case drug
    case food
    case record
    case user
    case support
    case askanexpert
}
class ImageUpload: NSObject {

    static let shared : ImageUpload = ImageUpload()
    
    func uploadImage(
        _ showLoader : Bool = true,
        _ image : UIImage? = nil,
        _ localUrl : String? = nil,
        _ mimeType : String,
        prefix: PrefixContainer,
        withBlock completion :((String? , String?) -> Void)?
        )
    {
        
        func removeLoader() {
            if let completion = completion {
                completion(nil,nil)
            }
            
            if showLoader {
                ApiManager.shared.removeLoader()
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        if showLoader {
            ApiManager.shared.addLoader()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //S3 bucket setup
        
        do {
            
            let connectionString = "DefaultEndpointsProtocol=https;AccountName=\(AzureCredentials.kAccountName);AccountKey=\(AzureCredentials.kAccessSecretKey)"
            let account = try AZSCloudStorageAccount(fromConnectionString:connectionString) //I stored the property in my header file
            let blobClient: AZSCloudBlobClient = account.getBlobClient()
            var blobContainer: AZSCloudBlobContainer!
            blobContainer = blobClient.containerReference(fromName: mimeType.self)
            
            var randomNameImage = "\(self.getRandomString())"
            if let val = localUrl {
                randomNameImage = val.components(separatedBy: "/").last! + "_" + randomNameImage
            }
            else {
                randomNameImage = "\(self.getRandomString()).jpeg"
            }
            
            randomNameImage = prefix.rawValue + "_" + randomNameImage
            
//            let blobDirectory = blobContainer.directoryReference(fromName: AzureCredentials.kDirectoryName.rawValue)
            let blob: AZSCloudBlockBlob = blobContainer.blockBlobReference(fromName: randomNameImage as String)
            ///If you want a random name, I used let imageName = CFUUIDCreateString(nil, CFUUIDCreate(nil))
            
            if let image = image {
                
                let imageData = image.jpegData(compressionQuality: 0.7)
                
                blob.upload(from: imageData!, completionHandler: {(error) -> Void in
                    if error == nil {
                        if let completion = completion {
                            debugPrint("🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲 Image Uploaded 🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲")
                            debugPrint(randomNameImage)
                            
                            completion(nil,randomNameImage)
                        }
                    } else {
                        print(error?.localizedDescription ?? "")
                        removeLoader()
                    }
                })
            } else if let localUrl = URL(string: localUrl ?? "") {
                
                blob.uploadFromFile(with: localUrl) { (error) in
                    if error == nil {
                        if let completion = completion {
                            debugPrint("🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲 Document Uploaded 🔲🔲🔲🔲🔲🔲🔲🔲🔲🔲")
                            debugPrint(localUrl)
                            
                            completion(nil,randomNameImage)
                        }
                    } else {
                        print(error?.localizedDescription ?? "")
                        removeLoader()
                    }
                }
            }
            else {
                removeLoader()
            }
            
//            blobContainer.createContainerIfNotExists(with: AZSContainerPublicAccessType.blob, requestOptions: nil, operationContext: nil) { (NSError, Bool) -> Void in
//                if ((NSError) != nil){
//                    print("Error in creating container.")
//                    removeLoader()
//                }
//                else {
//
//
//                }
//            }
        } catch let error {
            print("Unspecified Error: \(error)")
            removeLoader()
        }
        
        
        /*
        
        let credentialsProvider : AWSStaticCredentialsProvider = AWSStaticCredentialsProvider(accessKey: AWSBucketKeys.accessKey.rawValue, secretKey: AWSBucketKeys.secretKey.rawValue)
        let configuration : AWSServiceConfiguration = AWSServiceConfiguration(region: AWSRegionType.EUWest1, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        /*
         for offline support
         */
        var bodyURL : URL?
        if let image = image {
            
            if let url : URL = self.storeDataInDirectory(image) {
                bodyURL = url
            }
            
        } else if let localUrl = localUrl {
            bodyURL = localUrl.url()
        } else {
            return
        }
        
        let transferManager : AWSS3TransferManager = AWSS3TransferManager.default()
        
        let uploadRequest : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        
        uploadRequest.bucket = AWSBucketKeys.bucketName.rawValue
        
        uploadRequest.key = AWSBucketKeys.path.rawValue
        uploadRequest.key = uploadRequest.key! + bodyURL!.lastPathComponent
        
        uploadRequest.body = bodyURL!
        uploadRequest.contentType = mimeType
        uploadRequest.acl = .publicRead
        
        if let image = image {
            if let imgData : Data = image.jpegData(compressionQuality: 0.7) {
                uploadRequest.contentLength = NSNumber.init(integerLiteral: imgData.count)
            }
        } else if let localUrl = localUrl {
            
            guard let data = try? Data(contentsOf: localUrl.url()) else {
                print("There was an error!")
                return
            }
            
            uploadRequest.contentLength = NSNumber.init(integerLiteral: data.count)
            
        } else {
            return
        }
        
        transferManager.upload(uploadRequest).continueWith { (task : AWSTask) -> Any? in
            if showLoader {
                GFunction.shared.removeLoader()
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if task.error == nil {
                completion!(AWSBucketKeys.endPoint.rawValue + AWSBucketKeys.path.rawValue + uploadRequest.key! , bodyURL!.lastPathComponent)
            }
            else {
                completion!(nil,nil)
            }
            return nil
        }
        */
    }
    
    func storeDataInDirectory(_ data : UIImage) -> URL? {
        
        if let imgData : Data = data.jpegData(compressionQuality: 0.7) {
            
            // *** Get documents directory path *** //
            let paths1 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory1 = paths1[0] as String
            
            // *** Append video file name *** //
            let datapathT = documentsDirectory1.appending("/\(self.getRandomString()).jpeg")
            
            let tempURl : URL = URL(fileURLWithPath: datapathT)
            
            //        let urlT = tempURl.absoluteURL
            
            let urlT = tempURl
            // *** Remove video file data to path *** //
            let fileManager = FileManager.default
            
            do {
                try fileManager.removeItem(at: urlT)
            }
            catch {
                print("No Duplicate images")
            }
            
            // *** Write image file data to path *** //
            var strPathForFile = ""
            do {
                try imgData.write(to: urlT)
                return urlT
                
            } catch  {
                print("some error in preview image: ")
                return nil
            }
        }
        return nil
    }

    func getTimeStampFromDate() -> (double : Double,string : String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 : String = dateFormatter.string(from: Date())
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date2 : Date = dateFormatter1.date(from: date1)!
        let timeStamp = date2.timeIntervalSince1970
        
        return (timeStamp,String(format: "%f", timeStamp))
    }
    
    func getRandomString(length: Int = 10) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        let timeStamp = self.getTimeStampFromDate()
        return randomString + "\(String(format: "%0.0f", timeStamp.double))"
    }
}

