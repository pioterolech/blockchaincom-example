//
//  SymbolsRouter.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 06/12/2021.
//

import Foundation
import UIKit
import Cleanse

protocol SymbolsRouterInterface: AnyObject {
    func showSymbolDetails(symbol: String)
}

class SymbolsRouter: SymbolsRouterInterface {
    weak var navigationVC: UINavigationController?
    private let factory: Factory<SymbolsDetailAssistedFactory>

    init(factory: Factory<SymbolsDetailAssistedFactory>) {
        self.factory = factory
    }

    func showSymbolDetails(symbol: String) {
        navigationVC?.pushViewController(factory.build(symbol), animated: true)
    }
}
