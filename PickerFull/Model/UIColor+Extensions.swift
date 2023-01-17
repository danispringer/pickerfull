//
//  UIColor+Extensions.swift
//  PickerFull
//
//  Created by dani on 1/17/23.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit

/// From: https://gist.github.com/adamgraham/3ada1f7f4cdf8131dd3d2d95bd116cfc
/// An extension to provide conversion to and from HSL (hue, saturation, lightness) colors.
extension UIColor {

    /// The HSL (hue, saturation, lightness) components of a color.
    struct HSL: Hashable {

        /// The hue component of the color, in the range [0, 360°].
        var hue: CGFloat
        /// The saturation component of the color, in the range [0, 100%].
        var saturation: CGFloat
        /// The lightness component of the color, in the range [0, 100%].
        var lightness: CGFloat

    }

    /// The HSL (hue, saturation, lightness) components of the color.
    var hsl: HSL {
        var aHue = CGFloat()
        var aSaturation = CGFloat()
        var aBrightness = CGFloat()
        getHue(&aHue, saturation: &aSaturation, brightness: &aBrightness, alpha: nil)

        let light = ((2.0 - aSaturation) * aBrightness) / 2.0

        switch light {
            case 0.0, 1.0:
                aSaturation = 0.0
            case 0.0..<0.5:
                aSaturation = (aSaturation * aBrightness) / (light * 2.0)
            default:
                aSaturation = (aSaturation * aBrightness) / (2.0 - light * 2.0)
        }

        return HSL(hue: aHue * 360.0,
                   saturation: aSaturation * 100.0,
                   lightness: light * 100.0)
    }

    /// Initializes a color from HSL (hue, saturation, lightness) components.
    /// - parameter hsl: The components used to initialize the color.
    /// - parameter alpha: The alpha value of the color.
    convenience init(_ hsl: HSL, alpha: CGFloat = 1.0) {
        let myHue = hsl.hue / 360.0
        var mySaturation = hsl.saturation / 100.0
        let myLight = hsl.lightness / 100.0

        let thing = mySaturation * ((myLight < 0.5) ? myLight : (1.0 - myLight))
        let myBrightness = myLight + thing
        mySaturation = (myLight > 0.0) ? (2.0 * thing / myBrightness) : 0.0

        self.init(hue: myHue, saturation: mySaturation, brightness: myBrightness, alpha: alpha)
    }

}
