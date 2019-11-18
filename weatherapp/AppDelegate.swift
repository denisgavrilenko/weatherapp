//
//  AppDelegate.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/17/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let services: [WeatherServiceLocator] = [Weather.RealServiceLocator(), Weather.StaticServiceLocator()]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationConroller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let viewConroller = navigationConroller.viewControllers.first as! WeatherViewController
        viewConroller.set(services: services)

        window.rootViewController = navigationConroller
        window.makeKeyAndVisible()
        window.isHidden = false
        self.window = window
        return true
    }
}

