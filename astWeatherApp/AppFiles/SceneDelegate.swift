//
//  SceneDelegate.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 28.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let flowController = MainCoordinator()
        window.rootViewController = flowController
        self.window = window
        window.makeKeyAndVisible()
    }
}

