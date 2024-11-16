//
//  SceneDelegate.swift
//  SimpleWeather
//
//  Created by User on 14.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            
            guard let windowScene = (scene as? UIWindowScene) else { return }
            
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            
            let rootViewController = MainViewController()
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }

        
        func sceneDidDisconnect(_ scene: UIScene) {}
        
        func sceneDidBecomeActive(_ scene: UIScene) {}
        
        func sceneWillResignActive(_ scene: UIScene) {}
        
        func sceneWillEnterForeground(_ scene: UIScene) {}
        
        func sceneDidEnterBackground(_ scene: UIScene) {
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

