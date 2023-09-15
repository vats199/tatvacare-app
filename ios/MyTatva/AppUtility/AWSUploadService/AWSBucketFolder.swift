//
//  AWSBucketFolder.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 21/04/21.
//

import Foundation

/// This enum contain all the folder name inside the bucket.
enum AWSBucketFolder {
    
    case user
    case business_user
    case business
    case menu
    case deal
    
    private var folderName: String {
        switch self {
        case .user:
            return "user"
        case .business_user:
            return "business_user"
        case .business:
            return "business"
        case .menu:
            return "menu"
        case .deal:
            return "deal"
        }
    }
    
    var path: String {
        //"\(AWSUploadConfigration.bucket!)/\(self.folderName)/"
        "\(self.folderName)/"
    }
}
