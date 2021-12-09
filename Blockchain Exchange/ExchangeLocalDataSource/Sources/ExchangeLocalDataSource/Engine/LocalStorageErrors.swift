//
//  File.swift
//  
//
//  Created by Piotr Olechnowicz on 02/12/2021.
//

import Foundation

enum LocalStorageEngineErrors: Error, Equatable {
    case noCache
    case incorrectCacheDirectory
    case unableToDecode
    case unknownError
}
