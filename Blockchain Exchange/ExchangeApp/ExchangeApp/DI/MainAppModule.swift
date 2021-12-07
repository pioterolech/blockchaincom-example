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

    static func configure(binder: Binder<Singleton>) {
        binder.include(module: UIKitModule.self)
        binder.include(module: NavigationModule.self)
        binder.include(module: SymbolsModule.self)
    }

    static func configureRoot(binder bind: ReceiptBinder<Root>) -> BindingReceipt<Root> {
        return bind.propertyInjector(configuredWith: MainComponent.configureAppDelegateInjector)
    }

    static func configureAppDelegateInjector(binder bind: PropertyInjectionReceiptBinder<SceneDelegate>) -> BindingReceipt<PropertyInjector<SceneDelegate>> {
        return bind.to(injector: SceneDelegate.injectProperties)
    }
}

extension SceneDelegate {

    func injectProperties(_ window: UIWindow) {
        self.window = window
    }
}
