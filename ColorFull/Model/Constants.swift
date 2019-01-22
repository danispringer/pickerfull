//
//  Constants.swift
//  ColorFull
//
//  Created by Daniel Springer on 11/29/18.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit


struct Constants {

    struct UserDef {
        static let hexPickerSelected = "hexPickerSelected"
        static let colorKey = "color"
        static let defaultColor = "E57BF2"
        static let darkModeIsOn = "darkModeIsOn"
    }

    struct Values {
        static let numToHexFormatter = "%02X"
        static let hexToNumFormatter = "0x"
        static let rgbMax = 255.0
    }

    struct AppInfo {
        static let bundleShort = "CFBundleShortVersionString"
        static let appName = "ColorFull"
        static let galleryLink = "photos-redirect://"
        static let email = "***REMOVED***"
        static let reviewLink = "https://itunes.apple.com/app/id1410565176?action=write-review"
        static let bundleAndRandom = "io.github.danispringer.Color-Picker.makeRandom"
        static let showAppsButtonTitle = "More by Daniel Springer"
        static let appsLink = "https://itunes.apple.com/developer/id1402417666"
        static let creditMessage = """
        \n\nCreated using:
        ColorFull: Find Your Color
        by
        Daniel Springer
        Available exclusively on the iOS App Store\n
        """
    }

}
