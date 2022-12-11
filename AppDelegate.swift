//
//  AppDelegate.swift
//  PickerFull
//
//  Created by Daniel Springer on 06/03/2018.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit
import AVKit


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {


    // MARK: Properties

    var window: UIWindow?


    // MARK: Life Cycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
            UIApplication
                .LaunchOptionsKey: Any
        ]?) -> Bool {

            if CommandLine.arguments.contains("--pickerfullScreenshots") {
                // We are in testing mode, make arrangements
                UD.set(Const.UserDef.defaultColor, forKey: Const.UserDef.colorKey)
            } // TODO: for testing: add advanced history filled. redo screenshots..?

            UD.register(defaults: [
                Const.UserDef.colorKey: Const.UserDef.defaultColor,
                Const.UserDef.tutorialShown: false,
                Const.UserDef.xSavesShown: false
            ])

            let audioSession = AVAudioSession.sharedInstance()

            do {
                try audioSession.setCategory(.playback)
            } catch {
                print("Audio session failed")
            }

            return true
        }

}
