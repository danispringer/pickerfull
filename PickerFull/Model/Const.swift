//
//  Const.swift
//  PickerFull
//
//  Created by Daniel Springer on 11/29/18.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit

// swiftlint:disable:next identifier_name
let UD = UserDefaults.standard


struct Const {


    struct StoryboardIDIB {
        static let main = "Main"
        static let magicCell = "MagicCell"
        static let magicTableVC = "MagicTableVC"
        static let advancedCell = "advancedCell"
        static let advancedTableVC = "advancedTableVC"
        static let tutorialVC = "TutorialViewController"
        static let imagePreviewVC = "ImagePreviewViewController"
    }


    struct UserDef {
        static let colorKey = "color"
        static let defaultColor = "E57BF2"
        static let randomHistoryFilename = "colors.txt"
        static let advancedHistoryFilename = "colorsadvanced.txt"
        static let tutorialShown = "tutorialShown"
        static let xSavesShown = "xSavesShown"
    }

    struct Values {
        static let numToHexFormatter = "%02X"
        static let rgbMax = 255.0
    }

    struct AppInfo {
        static let version = "v."
        static let leaveReview = "Leave a Review"
        static let tutorial = "Watch Tutorial"
        static let shareApp = "Tell a Friend"
        static let addFromCamera = "Take Photo"
        static let okMessage = "OK"
        static let notNowMessage = "Not now"
        static let addFromGallery = "Choose Photo"
        static let clearImage = "Delete Photo"
        static let appVersion = "CFBundleShortVersionString"
        static let appName = "PickerFull - Color Extractor"
        static let galleryLink = "photos-redirect://"
        static let reviewLink = "https://apps.apple.com/app/id1410565176?action=write-review"
        static let showAppsButtonTitle = "More Apps"
        static let appsLink = "https://apps.apple.com/us/developer/daniel-springer/id1402417666"
        static let creditMessage = """
        \n\(appName)
        Install Now. Scan Qr Code for App Store.
        App Developed by Daniel Springer
        """
        static let contact = "Email Me"
        static let emailString = "00.segue_affix@icloud.com"
        static let historyHeader = """
        Tap a color to restore it to the home page of the app and share it
        """
    }

}
