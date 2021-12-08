//
//  SymbolsRouterModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import Cleanse
import UIKit

struct SymbolsRouterModule: Module {
    static func configure(binder: Binder<Unscoped>) {
        binder
            .bind(SymbolsRouter.self)
            .to { (navigation: UINavigationController, view: SymbolsListViewController, presenter: SymbolsListPresenter) -> SymbolsRouter in
                let router = SymbolsRouter(navigationVC: navigation, view: view)
                presenter.router = router
                return router
            }
    }
}
