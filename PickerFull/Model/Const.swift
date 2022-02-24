//
//  Const.swift
//  PickerFull
//
//  Created by Daniel Springer on 11/29/18.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit

// swiftlint:disable:next identifier_name
let UD = UserDefaults.standard


struct Const {


    struct StoryboardIDIB {
        static let main = "Main"
        static let magicCell = "MagicCell"
        static let magicTableVC = "MagicTableVC"
    }


    struct UserDef {
        static let colorKey = "color"
        static let defaultColor = "E57BF2"
        static let magicDict = "magicDictionary"
    }

    struct Values {
        static let numToHexFormatter = "%02X"
        static let rgbMax = 255.0
    }

    struct AppInfo {
        static let version = "v."
        static let leaveReview = "Leave a Review"
        static let sendFeedback = "Contact Us"
        static let shareApp = "Tell a Friend"
        static let addFromCamera = "Take Photo"
        static let addFromGallery = "Choose Photo"
        static let clearImage = "Delete Photo"
        static let magicHistory = "Magic History"
        static let bundleShort = "CFBundleShortVersionString"
        static let appName = "PickerFull"
        static let galleryLink = "photos-redirect://"
        static let email = "dani.springer@icloud.com"
        static let reviewLink = "https://apps.apple.com/app/id1410565176?action=write-review"
        static let bundleAndRandom = "io.github.danispringer.Color-Picker.makeRandom"
        static let showAppsButtonTitle = "More Apps"
        static let appsLink = "https://apps.apple.com/developer/id1402417666"
        static let creditMessage = """


        Screenshot created with
        PickerFull
        by
        Daniel Springer

        Create, edit and share your favorite colors
        Get it now on the App Store

        """
    }

}
