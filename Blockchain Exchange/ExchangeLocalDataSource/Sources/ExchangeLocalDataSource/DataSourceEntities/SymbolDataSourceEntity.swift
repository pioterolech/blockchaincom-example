//
//  File.swift
//  
//
//  Created by Piotr Olechnowicz on 02/12/2021.
//

import Foundation

public struct SymbolsDataSourceEntity: Codable {
    public let symbols: [String]

    public init(symbols: [String]) {
        self.symbols = symbols
    }
}
