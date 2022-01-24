//
//  Const.swift
//  ColorFull
//
//  Created by Daniel Springer on 11/29/18.
//  Copyright © 2021 Daniel Springer. All rights reserved.
//

import UIKit

// swiftlint:disable:next identifier_name
let UD = UserDefaults.standard


struct Const {


    struct StoryboardIDIB {
        static let main = "Main"
    }


    struct UserDef {
        static let colorKey = "color"
        static let defaultColor = "E57BF2"
    }

    struct Values {
        static let numToHexFormatter = "%02X"
        static let hexToNumFormatter = "0x"
        static let rgbMax = 255.0
    }

    struct AppInfo {
        static let version = NSLocalizedString("v.", comment: "")
        static let leaveReview = NSLocalizedString("Leave a Review", comment: "")
        static let sendFeedback = NSLocalizedString("Contact Us", comment: "")
        static let shareApp = NSLocalizedString("Tell a Friend", comment: "")
        static let addFromCamera = NSLocalizedString("Take Photo", comment: "")
        static let addFromGallery = NSLocalizedString("Choose Photo", comment: "")
        static let clearImage = NSLocalizedString("Delete Photo", comment: "")
        static let bundleShort = "CFBundleShortVersionString"
        static let appName = NSLocalizedString("ColorFull", comment: "")
        static let galleryLink = "photos-redirect://"
        static let email = "dani.springer@icloud.com"
        static let reviewLink = "https://itunes.apple.com/app/id1410565176?action=write-review"
        static let bundleAndRandom = "io.github.danispringer.Color-Picker.makeRandom"
        static let showAppsButtonTitle = NSLocalizedString("More Apps", comment: "")
        static let appsLink = "https://itunes.apple.com/developer/id1402417666"
        static let creditMessage = NSLocalizedString("""


        Screenshot created with
        ColorFull - Your Color Awaits
        by
        Daniel Springer

        Create, edit and share your favorite colors
        Get it now on the App Store

        """, comment: "")
    }

}
