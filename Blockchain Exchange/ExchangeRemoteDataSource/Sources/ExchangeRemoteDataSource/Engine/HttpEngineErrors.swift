//
//  File.swift
//  
//
//  Created by Piotr Olechnowicz on 02/12/2021.
//

import Foundation

enum HttpEngineErrors: Error, Equatable {
    case invalidResponse
    case emptyResponse
    case invalidURL
    case clientError
    case serverError
    case redirectionError
    case unknownError

    static func error(for code: Int) -> HttpEngineErrors {
        switch code {
        case 300..<400:
            return .redirectionError
        case 400..<500:
            return .clientError
        case 500..<600:
            return .serverError
        default:
            return .unknownError
        }
    }
}
