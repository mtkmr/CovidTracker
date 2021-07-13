//
//  AppDelegate.swift
//  CovidTracker
//
//  Created by Masato Takamura on 2021/07/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Router.shared.showRoot(window: UIWindow(frame: UIScreen.main.bounds))
        return true
    }
}

