//
//  File.swift
//  
//
//  Created by Piotr Olechnowicz on 02/12/2021.
//

import Foundation

struct URLFactory {
    struct Api {
        static let path: String = "https://api.blockchain.com/"
        static let version: String = "v3"
    }

    struct Exchange {
        static let symbols = "/exchange/symbols"
    }

    var symbols: String {
        Api.path + Api.version + Exchange.symbols
    }
}
