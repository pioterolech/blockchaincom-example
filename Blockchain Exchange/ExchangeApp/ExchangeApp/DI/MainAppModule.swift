//
//  MainAppModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 07/12/2021.
//

import Foundation
import Cleanse
import UIKit

struct MainComponent: Cleanse.RootComponent {

    typealias Root = PropertyInjector<SceneDelegate>
    typealias Scope = Singleton
    typealias Seed = UIWindowScene
    typealias PropertyInjectorBinder  = PropertyInjectionReceiptBinder<SceneDelegate>

    static func configure(binder: Binder<Singleton>) {
        binder.include(module: UIKitModule.self)
        binder.include(module: NavigationModule.self)
        binder.include(module: SymbolsRouterModule.self)
        binder.include(module: SymbolsListModule.self)
        binder.include(module: ExchangeAPIModule.self)
        binder.include(module: ExchangeServiceModule.self)
    }

    static func configureRoot(binder bind: ReceiptBinder<Root>) -> BindingReceipt<Root> {
        return bind.propertyInjector(configuredWith: MainComponent.configureAppDelegateInjector)
    }

    static func configureAppDelegateInjector(binder bind: PropertyInjectorBinder) -> BindingReceipt<Root> {
        return bind.to(injector: SceneDelegate.injectProperties)
    }
}

extension SceneDelegate {

    func injectProperties(_ window: UIWindow) {
        self.window = window
    }
}
