//
//  AWSFileMimeType.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 20/04/21.
//

import Foundation

enum AWSFileMimeType: String {
    case jpeg = "image/jpeg"
    case gif = ""
    case video = "video/quicktime"
    
    var extesion: String {
        switch self {
        case .jpeg:
            return ".jpeg"
        case .gif:
            return ""
        case .video:
            return ".mp4"
        }
    }
}
