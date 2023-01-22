//
//  AppDelegate.swift
//  PickerFull
//
//  Created by Daniel Springer on 06/03/2018.
//  Copyright © 2023 Daniel Springer. All rights reserved.
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

                for filename in [Const.UserDef.randomHistoryFilename,
                                 Const.UserDef.advancedHistoryFilename] {
                    var currentArray: [String] = readFromDocs(
                        withFileName: filename) ?? []
                    currentArray = []
                    saveToDocs(text: currentArray.joined(separator: ","),
                               withFileName: filename)
                }

            }

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


    func readFromDocs(withFileName fileName: String) -> [String]? {
        guard let filePath = append(toPath: self.documentDirectory(),
                                    withPathComponent: fileName) else {
            return nil
        }
        do {
            let savedString = try String(contentsOfFile: filePath)
            let myArray = savedString.components(separatedBy: ",")
            if myArray.isEmpty {
                return nil
            } else {
                if myArray.count == 1 && myArray.first == "" {
                    return nil
                }
                return myArray
            }
        } catch {
            // print("Error reading saved file")
            return nil
        }
    }


    func saveToDocs(text: String,
                    withFileName fileName: String) {
        guard let filePath = self.append(toPath: documentDirectory(),
                                         withPathComponent: fileName) else {
            return
        }

        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error", error)
            return
        }
    }


    private func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true)
        return documentDirectory[0]
    }


    private func append(toPath path: String,
                        withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)

            return pathURL.absoluteString
        }

        return nil
    }

}
