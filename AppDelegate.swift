//
//  AppDelegate.swift
//  PickerFull
//
//  Created by Daniel Springer on 06/03/2018.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {


    // MARK: Properties

    var window: UIWindow?

    var launchedShortcutItem: UIApplicationShortcutItem?


    // MARK: Life Cycle

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if CommandLine.arguments.contains("--pickerfullScreenshots") {
            // We are in testing mode, make arrangements

        }

        UD.register(defaults: [
            Const.UserDef.colorKey: Const.UserDef.defaultColor,
            Const.UserDef.userGotAdvancedWarning: true // for now...
        ])

        if let shortcutItem = launchOptions?[
            UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {

            launchedShortcutItem = shortcutItem

            // Since, the app launch is triggered by QuicAction, block "performActionForShortcutItem:completionHandler"
            // method from being called.
            return false
        }

        return true
    }


    // MARK: long press app icon

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {

        let viewController = window?.rootViewController as? MakerViewController
        viewController?.makeRandomColor()

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
