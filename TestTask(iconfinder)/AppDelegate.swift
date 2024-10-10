//
//  AppDelegate.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 15.09.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let iconSearcherModule = ModuleIconSearcherFactory().make()

        let nav = UINavigationController(rootViewController: iconSearcherModule)

        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        appearance.backgroundColor = .white

        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance

        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        return true
    }
}
