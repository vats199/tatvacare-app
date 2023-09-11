//
//  AppError.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 03/03/21.
//

import Foundation

// Credit: https://stackoverflow.com/a/57081275/14733292

enum AppError {
    case network(type: Enums.NetworkError)
    case file(type: Enums.FileError)
    case validation(type: Enums.ValidationError)
    case dataSource(type: Enums.DataSourceError)
    case custom(errorDescription: String?)
    class Enums { }
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .network(let type): return type.localizedDescription
        case .file(let type): return type.localizedDescription
        case .validation(let type): return type.localizedDescription
        case .dataSource(let type): return type.localizedDescription
        case .custom(let errorDescription): return errorDescription
        }
    }
}
