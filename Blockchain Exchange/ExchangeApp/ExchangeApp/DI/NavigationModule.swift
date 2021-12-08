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
    struct RootViewTag: Tag {
        typealias Element = UINavigationController
    }

    static func configure(binder: Binder<Unscoped>) {
        binder
          .bind(UINavigationController.self)
          .tagged(with: RootViewTag.self)
          .to(factory: { (symbolsVC: SymbolsListViewController) -> UINavigationController in
              let rootNav = UINavigationController()
              rootNav.viewControllers = [symbolsVC]
              return rootNav
          })
    }

}
