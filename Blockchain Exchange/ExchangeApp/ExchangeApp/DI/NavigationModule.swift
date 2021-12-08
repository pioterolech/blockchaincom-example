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
          .to(factory: { () -> UINavigationController in
              return UINavigationController()
          })
    }
}
