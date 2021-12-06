//
//  SceneDelegate.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 05/12/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let symbols = ViewController()
            let navigation = UINavigationController(rootViewController: symbols)
            window.rootViewController = navigation
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
