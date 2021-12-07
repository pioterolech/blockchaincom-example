//
//  RootModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 07/12/2021.
//

import UIKit
import Cleanse

struct UIKitModule: Cleanse.Module {

    static func configure(binder: Binder<Unscoped>) {
        binder.include(module: UIScreenModule.self)
        binder.include(module: UIWindowModule.self)
    }

}

struct UIScreenModule: Cleanse.Module {
    static func configure(binder: Binder<Unscoped>) {
        binder.bind(UIScreen.self).to { UIScreen.main }
    }
}

struct UIWindowModule: Cleanse.Module {
    static func configure(binder: Binder<Unscoped>) {
        typealias RootProvider = TaggedProvider<NavigationModule.RootViewTag>

        binder
            .bind(UIWindow.self)
            .to { (rootViewController: RootProvider, windowScene: UIWindowScene) -> UIWindow in
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = rootViewController.get()
                return window
            }
    }
}
