//
//  File.swift
//  
//
//  Created by Piotr Olechnowicz on 02/12/2021.
//

import Foundation

public struct URLFactory {
    public static func create() -> URLFactory {
        .init()
    }

    struct Api {
        static let path: String = "https://api.blockchain.com/"
        static let version: String = "v3"
    }

    struct Exchange {
        static let symbols = "/exchange/symbols"
        static func prices(symbol: String) -> String {
            let prefix = "nabu-gateway/markets/exchange/prices?symbol="
            let suffix = "&start=1604423853088&end=1638983853088&granularity=86400"
            return prefix+symbol+suffix
        }
    }

    var symbols: String {
        Api.path + Api.version + Exchange.symbols
    }

    func prices(symbol: String) -> String {
        Api.path + Exchange.prices(symbol: symbol)
    }
}
