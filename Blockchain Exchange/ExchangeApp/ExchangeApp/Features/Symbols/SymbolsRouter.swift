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
    private let navigationVC: UINavigationController

    init(navigationVC: UINavigationController, view: SymbolsListViewController) {
        self.navigationVC = navigationVC
        navigationVC.viewControllers = [view]
    }

    func showSymbolDetails(symbol: String) {
    }
}
