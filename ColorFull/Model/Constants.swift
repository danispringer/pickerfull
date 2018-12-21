//
//  Constants.swift
//  ColorFull
//
//  Created by Daniel Springer on 11/29/18.
//  Copyright © 2018 Daniel Springer. All rights reserved.
//

import Foundation

struct Constants {
    struct UserDef {
        static let hexPickerSelected = "hexPickerSelected"
        static let colorKey = "color"
        static let isFirstLaunch = "isFirstLaunch"
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
    }
    struct Image {
        static let red = "red.png"
        static let green = "green.png"
        static let blue = "blue.png"
    }

}
