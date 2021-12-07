//
//  SceneDelegate.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 05/12/2021.
//

import UIKit
import Cleanse

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var componentFactory: ComponentFactory<MainComponent>?
    var componentFactoryInjector: PropertyInjector<SceneDelegate>?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        do {
            componentFactory = try ComponentFactory.of(MainComponent.self)
            componentFactoryInjector = componentFactory?.build(windowScene)
            componentFactoryInjector?.injectProperties(into: self)
            window?.makeKeyAndVisible()
        } catch {
            assertionFailure("Unable to load app dependencies :\(error)")
        }
    }
}
