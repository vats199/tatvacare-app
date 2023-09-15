//
//  Downloader.swift
//  CabyDriver
//
//  Created by apple on 13/08/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import FileProvider

class Downloader: NSObject {
    
    static let shared = Downloader()
    
    static private var alertSaveProgress        : UIAlertController?
    static private var progressView             : UIProgressView?
    static private var docController            : UIDocumentInteractionController!
    static private var printController          = UIPrintInteractionController.shared
    static private var progressValue: Float     = 0
    static private var title: String            = ""
    
    func load(url: URL, withName: String = "") {
        debugPrint("Document URL:- \(url) ")
        
        if withName.trim() != "" {
            Downloader.title    = withName
        }
        else {
            let arr             = url.lastPathComponent.components(separatedBy: ".")
            Downloader.title    = arr.count > 0 ? arr[0] : ""
        }
        
        let configuration   = URLSessionConfiguration.default
        let operationQueue  = OperationQueue()
        let session         = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        let downloadTask    = session.downloadTask(with: url)
   
        DispatchQueue.main.async {
            Downloader.alertSaveProgress = UIAlertController(title: "Please wait", message: "Downloading...", preferredStyle: .alert)
            
            Downloader.alertSaveProgress!.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { UIAlertAction in
                downloadTask.cancel()
            }))
            
            //Show it to your users
            UIApplication.topViewController()?.present(Downloader.alertSaveProgress!, animated: true, completion: {
                //  Add your progressbar after alert is shown (and measured)
                let margin:CGFloat = 8.0
                let rect = CGRect(x: margin, y: 72.0, width: Downloader.alertSaveProgress!.view.frame.width - margin * 2.0 , height: 2.0)
                Downloader.progressView               = UIProgressView(frame: rect)
                Downloader.progressView!.tintColor    = UIColor.themePurple
                Downloader.alertSaveProgress!.view.addSubview(Downloader.progressView!)
                downloadTask.resume()
            })
        }
    }
    
    // MARK: prepare url from string
    class private func getURLFromString(_ str: String) -> URL? {
        return URL(string: str)
    }
    
    // MARK: set data to save
    class private func saveDownloadedFile(from data: Data?, URL: URL) {
        guard let pdfData = data else { return }
        
        // Get the Document Directory path of the Application
        let resourceDocPath = (FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)).last! as URL
        
        // Split the url into a string Array by separator "/" to get the pdf name
        let pdfNameFromUrlArr = URL.absoluteString.components(separatedBy: "/")
        
        // Appending the Document Directory path with the pdf name
//        let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrlArr[
//            pdfNameFromUrlArr.count - 1] + ".pdf")
        
        var actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrlArr[pdfNameFromUrlArr.count - 1] + ".pdf")
        if Downloader.title.trim() != "" {
//            actualPath = resourceDocPath.appendingPathComponent(Downloader.title + ".pdf")
            actualPath = resourceDocPath.appendingPathComponent(Downloader.title)
        }
        
        Downloader.deleteAllFiles()
        if FileManager().fileExists(atPath: actualPath.path) {
            
        }
        else {
            // Writing the PDF file data to the Document Directory Path
            do {
                _ = try pdfData.write(to: actualPath, options: .atomic)
                
                //AppLoader.shared.removeLoader()
                print("Pdf saved at \(actualPath)")
                //Alert.shared.showSnackBar("Download Completed")
                
                //            self.docController = UIDocumentInteractionController(url: actualPath)
                //
                //            self.docController.presentOptionsMenu(from: (UIApplication.topViewController()!.view.frame), in: (UIApplication.topViewController()!.view!), animated: true)
                
                
                DispatchQueue.main.async {
                    if let _ = PDFDocument(url: actualPath) {
                        let readerController = ViewPDFVC.instantiate(fromAppStoryboard: .setting)
                        readerController.hidesBottomBarWhenPushed = true
                        readerController.strUrl = actualPath.description
                        readerController.strTitle  = Downloader.title
                        UIApplication.topViewController()?.navigationController?.pushViewController(readerController, animated: true)
                    }
                    else {
                        Downloader.printController               = UIPrintInteractionController.shared
                        Downloader.printController.printingItem  = actualPath
                        Downloader.printController.showsPaperSelectionForLoadedPapers = true
                        
                        let printInfo                           = UIPrintInfo.printInfo()
                        printInfo.outputType                    = .photo
                        Downloader.printController.printInfo    = printInfo
                        Downloader.printController.present(from: (UIApplication.topViewController()!.view.frame), in: (UIApplication.topViewController()!.view!), animated: true)
                    }
                    
                    
                    
//                    if let document = PDFDocument(url: actualPath) {
//                        let readerController                    = PDFViewController.createNew(with: document,
//                                                                                              title: Downloader.title,
//                                                                                              actionStyle: .activitySheet,
//                                                                                              isThumbnailsEnabled: false)
//                        readerController.hidesBottomBarWhenPushed = true
//                        readerController.backgroundColor        = UIColor.white
//                        readerController.scrollDirection        = .vertical
////                        readerController.isThumbnailsEnabled    = false
//                        UIApplication.topViewController()?.navigationController?.pushViewController(readerController, animated: true)
//                        //UIApplication.topViewController()?.navigationController?.pushViewController(readerController, animated: true)
//                    }
//                    else {
//                        Downloader.printController               = UIPrintInteractionController.shared
//                        Downloader.printController.printingItem  = actualPath
//                        Downloader.printController.showsPaperSelectionForLoadedPapers = true
//
//                        let printInfo                           = UIPrintInfo.printInfo()
//                        printInfo.outputType                    = .photo
//                        Downloader.printController.printInfo    = printInfo
//                        Downloader.printController.present(from: (UIApplication.topViewController()!.view.frame), in: (UIApplication.topViewController()!.view!), animated: true)
//                    }
                }
                
            }catch{
    //            AppLoader.shared.removeLoader()
                print("Pdf can't be saved")
            }
        }
    }
    
    // MARK: read downloaded data
    class private func readDownloadedData(of url: URL) -> Data? {
        do {
            let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
            
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    class func deleteAllFiles(){
        let fileManager     = FileManager.default
        let documentsUrl    = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath   = documentsUrl.path
        
        do {
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache: \(fileNames)")
                for fileName in fileNames {
                    
                    let filePathName = "\(documentPath)/\(fileName)"
                    try fileManager.removeItem(atPath: filePathName)
                }
                
                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache after deleting images: \(files)")
            }
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
}

//MARK: ------------------- URLSessionDownload Delegate Methods -------------------
extension Downloader: URLSessionDownloadDelegate {
    
    // MARK: protocol stub for download completion tracking
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        // get downloaded data from location
        let data = Downloader.readDownloadedData(of: location)
        
        DispatchQueue.main.async {
            Downloader.alertSaveProgress?.dismiss(animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
            // set image to imageview
            Downloader.saveDownloadedFile(from: data, URL: location)
        }
    }
    
    // MARK: protocol stubs for tracking download progress
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentDownloaded = (totalBytesWritten * 100) / totalBytesExpectedToWrite
        
        // update the percentage label
        Downloader.progressValue = Float(percentDownloaded)
        DispatchQueue.main.async {
            print("\(Downloader.progressValue)%")
            Downloader.progressView?.progress = Downloader.progressValue * 0.01
        }
    }
}
