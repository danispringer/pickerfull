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


    // MARK: Life Cycle

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UserDefaults.standard.register(defaults: [
            Constants.UserDef.isFirstLaunch: true,
            Constants.UserDef.colorKey: Constants.UserDef.defaultColor,
            Constants.UserDef.hexPickerSelected: true])
        return true
    }


    // MARK: Siri Shortcuts

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        let viewController = window?.rootViewController as? MakerViewController
        viewController?.makeRandomColor()

        return true
    }

}
