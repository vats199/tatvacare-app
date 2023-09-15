//
//  URL+Extension.swift
//  MVVMBasicStructure

//  Copyright © 2023 Darshan Joshi. All rights reserved.
//
import Foundation

extension URL {
    var queryDictionary: [String: String]? {
        var queryStrings: [String: String]?
        
        if let query = self.query {
        queryStrings = [String: String]()
            for pair in query.components(separatedBy: "&") {
                
                let key = pair.components(separatedBy: "=")[0]
                
                let value = pair
                    .components(separatedBy:"=")[1]
                    .replacingOccurrences(of: "+", with: " ")
                    .removingPercentEncoding ?? ""
                
                queryStrings?[key] = value
            }
        }
        else {
            queryStrings = [String: String]()
            let arr = self.absoluteString.components(separatedBy: "&")
            if arr.count > 0 {
                for item in arr {
                    let arrDict = (JSON(item).stringValue.components(separatedBy: "="))
                    if arrDict.count > 1 {
                        queryStrings?[arrDict.first!] = arrDict.last!
                    }
                }
            }
        }
        
        return queryStrings
    }
    
    func resolveWithCompletionHandler(completion: @escaping (URL) -> Void) {
        let originalURL = self
        var req = URLRequest(url: originalURL)
        req.httpMethod = "HEAD"

        URLSession.shared.dataTask(with: req) { body, response, error in
            completion(response?.url ?? originalURL)
            }.resume()
    }
    
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}
