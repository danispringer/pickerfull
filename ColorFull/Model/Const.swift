//
//  Const.swift
//  ColorFull
//
//  Created by Daniel Springer on 11/29/18.
//  Copyright © 2021 Daniel Springer. All rights reserved.
//

import UIKit

let UDstan = UserDefaults.standard

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
        static let version = "v."
        static let leaveReview = "Leave a Review"
        static let sendFeedback = "Contact Us"
        static let shareApp = "Tell a Friend"
        static let bundleShort = "CFBundleShortVersionString"
        static let appName = "ColorFull"
        static let galleryLink = "photos-redirect://"
        static let email = "dani.springer@icloud.com"
        static let reviewLink = "https://itunes.apple.com/app/id1410565176?action=write-review"
        static let bundleAndRandom = "io.github.danispringer.Color-Picker.makeRandom"
        static let showAppsButtonTitle = "More Apps"
        static let appsLink = "https://itunes.apple.com/developer/id1402417666"
        static let creditMessage = """


        Screenshot created with
        ColorFull: Your Color Awaits
        by
        Daniel Springer

        Create, edit and share your favorite colors
        Get it now on the App Store

        """
    }

}
