//
//  AppDelegate.swift
//  ColorFull
//
//  Created by Daniel Springer on 06/03/2018.
//  Copyright © 2018 Daniel Springer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UserDefaults.standard.register(defaults: ["isFirstLaunch": true])
        UserDefaults.standard.register(defaults: [Constants.UserDef.colorKey: "E57BF2"])

        return true
    }

}
