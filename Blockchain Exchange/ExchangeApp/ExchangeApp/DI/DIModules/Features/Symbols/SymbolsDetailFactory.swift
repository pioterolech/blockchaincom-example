//
//  SymbolsDetailFactory.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 09/01/2022.
//

import Foundation
import Cleanse

class SymbolsDetailFactory {
    private let factory: Factory<SymbolsDetailAssistedFactory>

    init(factory: Factory<SymbolsDetailAssistedFactory>) {
        self.factory = factory
    }

    func createSymbolsDetail(symbol: String) -> SymbolsDetailViewController {
        factory.build(symbol)
    }
}
