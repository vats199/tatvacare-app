//
//  DataSourceError.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 28/02/21.
//

import Foundation

//MARK: DataSourceError

extension AppError.Enums {
    enum DataSourceError {
        case noDataFound
        case custom(errorDescription: String?)
    }
}

extension AppError.Enums.DataSourceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noDataFound: return "No data found"
        case .custom(let errorDescription): return errorDescription
        }
    }
}
