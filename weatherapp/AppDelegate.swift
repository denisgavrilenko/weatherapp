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
    let services = Weather.RealServiceLocator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewConroller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! WeatherViewController
        viewConroller.set(service: services)

        window.rootViewController = viewConroller
        window.makeKeyAndVisible()
        window.isHidden = false
        self.window = window
        return true
    }
}

