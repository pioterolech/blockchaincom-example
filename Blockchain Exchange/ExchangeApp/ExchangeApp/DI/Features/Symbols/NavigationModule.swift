//
//  SymbolsListModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 07/12/2021.
//

import Foundation
import Cleanse
import UIKit

struct NavigationModule: Cleanse.Module {

    static func configure(binder: Binder<Singleton>) {
        binder
          .bind(UINavigationController.self)
          .sharedInScope()
          .to(factory: { (view: SymbolsListViewController, router: SymbolsRouter) -> UINavigationController in
              let nav = UINavigationController(rootViewController: view)
              router.navigationVC = nav
              return nav
          })
    }
}
