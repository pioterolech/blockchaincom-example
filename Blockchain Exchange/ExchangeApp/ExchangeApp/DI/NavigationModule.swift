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
          .to(factory: { (symbolsList: SymbolsListViewController) -> UINavigationController in
              let mainNavigation = UINavigationController()
              mainNavigation.viewControllers = [symbolsList]
              return mainNavigation
          })
    }

}
