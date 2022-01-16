//
//  SceneDelegate.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 05/12/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let appFactory: AppFactory = .init()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        appFactory.createApp(scene, sceneDelegate: self)
    }
}
