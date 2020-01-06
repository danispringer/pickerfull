//
//  Constants.swift
//  ColorFull
//
//  Created by Daniel Springer on 11/29/18.
//  Copyright © 2020 Daniel Springer. All rights reserved.
//

import UIKit


struct Constants {


    struct StoryboardID {
        static let appIconViewController = "AppIconViewController"
        static let randomHistoryViewController = "RandomHistoryViewController"
        static let main = "Main"
    }

    struct CellID {
        static let appIconCell = "AppIconCell"
        static let randomHistoryCell = "randomHistoryCell"
    }

    struct UserDef {
        static let hexPickerSelected = "hexPickerSelected"
        static let colorKey = "color"
        static let defaultColor = "E57BF2"
        static let selectedIcon = "selectedIcon"
        static let isFirstTapOnRandomButton = "isFirstTapOnRandomButton"
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
        static let email = "musicbyds@icloud.com"
        static let reviewLink = "https://itunes.apple.com/app/id1410565176?action=write-review"
        static let bundleAndRandom = "io.github.danispringer.Color-Picker.makeRandom"
        static let showAppsButtonTitle = "More by Daniel Springer"
        static let appsLink = "https://itunes.apple.com/developer/id1402417666"
        static let creditMessage = """


        Screenshot created with
        ColorFull: Find Your Color
        by
        Daniel Springer

        Create, edit and share your favorite colors
        Get it now on the App Store

        """
    }

}
