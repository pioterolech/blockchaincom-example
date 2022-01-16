//
//  SymbolsRouter.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 06/12/2021.
//

import Foundation
import UIKit

protocol SymbolsRouterInterface: AnyObject {
    func showSymbolDetails(symbol: String)
}

class SymbolsRouter: SymbolsRouterInterface {
    weak var navigationVC: UINavigationController?
    private let detailsFactory: SymbolsDetailFactory

    init(detailsFactory: SymbolsDetailFactory) {
        self.detailsFactory = detailsFactory
    }

    func showSymbolDetails(symbol: String) {
        navigationVC?.pushViewController(detailsFactory.createSymbolsDetail(symbol: symbol), animated: true)
    }
}
