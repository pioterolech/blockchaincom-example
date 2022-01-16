//
//  File.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 09/01/2022.
//

import Foundation
import UIKit
import Cleanse

class AppFactory {
    var componentFactory: ComponentFactory<MainComponent>?
    var componentFactoryInjector: PropertyInjector<AppFactory>?
    var window: UIWindow?

    func createApp(_ scene: UIScene, sceneDelegate: SceneDelegate) {
        guard let windowScene = scene as? UIWindowScene else {
            assertionFailure("unable to create app, unable to create UIWindowScene")
            return
        }

        do {
            componentFactory = try ComponentFactory.of(MainComponent.self)
            componentFactoryInjector = componentFactory?.build(windowScene)
            componentFactoryInjector?.injectProperties(into: self)
            window?.makeKeyAndVisible()
        } catch {
            assertionFailure("unable to load app dependencies :\(error)")
        }
    }
}

extension AppFactory {
    func injectProperties(_ window: UIWindow) {
        self.window = window
    }
}
