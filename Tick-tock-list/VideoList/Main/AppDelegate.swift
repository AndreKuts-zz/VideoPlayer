//
//  AppDelegate.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/24/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var navigationController = makeNavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        registerDependencies()
        setupWindow()
        startMainFlow()

        return true
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }

    private func startMainFlow() {
        let mainViewController = MainSceneBuilder.makeMainViewController()
        window?.rootViewController = mainViewController
    }

    private func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setToolbarHidden(true, animated: false)
        return navigationController
    }

    private func registerDependencies() {
        let networking = Networking()
        DependenciesInjector.register(singleton: networking as UserListNetworking)
    }
}
