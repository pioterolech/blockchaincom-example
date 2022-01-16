//
//  RootModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 07/12/2021.
//

import UIKit
import Cleanse

struct UIKitModule: Cleanse.Module {
    static func configure(binder: Binder<Singleton>) {
        binder.include(module: UIScreenModule.self)
        binder.include(module: UIWindowModule.self)
    }
}

struct UIScreenModule: Cleanse.Module {
    static func configure(binder: Binder<Singleton>) {
        binder.bind(UIScreen.self).to { UIScreen.main }
    }
}

struct UIWindowModule: Cleanse.Module {
    static func configure(binder: Binder<Singleton>) {
        binder
            .bind(UIWindow.self)
            .to { (rootViewController: UINavigationController, windowScene: UIWindowScene) -> UIWindow in
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = rootViewController
                return window
            }
    }
}
