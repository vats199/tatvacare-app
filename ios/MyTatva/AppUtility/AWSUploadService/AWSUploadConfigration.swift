//
//  AWSUploadConfigration.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 21/04/21.
//

import Foundation
import AWSCore
import AWSS3

/// This enum contain all the keys and configration of AWS account.

class AWSUploadConfigration {
    static var bucket: String! = ""
    static var accessKeyID: String! = ""
    static var secretKey: String! = ""
    static var basePath: String! = ""
    
    static var regionType: AWSRegionType {
        .USEast1
    }
    
    init(){
        AWSUploadConfigration.bucket        = "happyourapp"//awsAppConfig.bucket.trim()//"bucket-name"
        AWSUploadConfigration.accessKeyID   = "AKIA35PGFLECCT6DAI5S"//awsAppConfig.accessKey.trim()//"accessKeyID"
        AWSUploadConfigration.secretKey     = "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"//awsAppConfig.secretAccessKey.trim()//"secretKey"
        AWSUploadConfigration.basePath      = "https://happyourapp.s3.amazonaws.com/"//awsAppConfig.url.trim()
    }
    
}

