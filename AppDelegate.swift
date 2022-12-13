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
                UD.set(false, forKey: Const.UserDef.tutorialShown)
                UD.set(false, forKey: Const.UserDef.xSavesShown)

                do {
                    try FileManager.default.removeItem(atPath: documentDirectory())
                } catch {
                    print("oops")
                }


            }

            UD.register(defaults: [
                Const.UserDef.colorKey: Const.UserDef.defaultColor,
                Const.UserDef.tutorialShown: false,
                Const.UserDef.xSavesShown: false
            ])
            // TODO: automate doable screenshots & use plain (add 2nd history)

            let audioSession = AVAudioSession.sharedInstance()

            do {
                try audioSession.setCategory(.playback)
            } catch {
                print("Audio session failed")
            }

            return true
        }


    private func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true)
        return documentDirectory[0]
    }

}
