//
//  SymbolsRouterModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import Cleanse
import UIKit
import WebKit

struct SymbolsRouterModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder
            .bind(SymbolsRouter.self)
            .sharedInScope()
            .to { (factory: Factory<SymbolsDetailAssistedFactory>) -> SymbolsRouter in
                return SymbolsRouter(factory: factory)
            }
    }
}
