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
    typealias Root = PropertyInjector<AppFactory>
    typealias Scope = Singleton
    typealias Seed = UIWindowScene
    typealias PropertyInjectorBinder  = PropertyInjectionReceiptBinder<AppFactory>

    static func configure(binder: Binder<Singleton>) {
        binder.include(module: UIKitModule.self)
        binder.include(module: NavigationModule.self)
        binder.include(module: SymbolDetailModule.self)
        binder.include(module: SymbolsListModule.self)
        binder.include(module: SymbolsRouterModule.self)
        binder.include(module: ExchangeLocalDataSourceModule.self)
        binder.include(module: ExchangeRemoteDataSourceModule.self)
        binder.include(module: ExchangeRepositoryModule.self)
    }

    static func configureRoot(binder bind: ReceiptBinder<Root>) -> BindingReceipt<Root> {
        return bind.propertyInjector(configuredWith: MainComponent.configureUIWindowInjector)
    }

    static func configureUIWindowInjector(binder bind: PropertyInjectorBinder) -> BindingReceipt<Root> {
        return bind.to(injector: AppFactory.injectProperties)
    }
}

