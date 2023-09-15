//
//  APIResultHandler.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 16/02/21.
//

import Foundation

//MARK: DataSourceError
enum APIError: Error {
    case noDataFound
    case custom(message: String)
    
    var description: String {
        switch self {
        case .noDataFound:
            return "No data found"
            
        case .custom(let msg):
            return msg
        }
    }
}
