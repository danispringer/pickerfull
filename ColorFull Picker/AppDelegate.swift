//
//  AppDelegate.swift
//  Color Picker
//
//  Created by Dani Springer on 06/03/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    var window: UIWindow?
    var preLaunchBrightness: CGFloat!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        preLaunchBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1.0
        print("6: \(preLaunchBrightness)")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        UIScreen.main.brightness = preLaunchBrightness
        print("1: \(preLaunchBrightness)")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIScreen.main.brightness = preLaunchBrightness
        print("2: \(preLaunchBrightness)")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIScreen.main.brightness = 1.0
        print("3: \(preLaunchBrightness)")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        preLaunchBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1.0
        print("4: \(preLaunchBrightness)")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UIScreen.main.brightness = preLaunchBrightness
        print("5: \(preLaunchBrightness)")
    }


}

