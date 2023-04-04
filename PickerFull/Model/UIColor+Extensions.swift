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


extension UIColor {
    // swiftlint:disable:next large_tuple
    func colorComponentsByMatchingToCMYK() -> (cyan: CGFloat, magenta: CGFloat,
                                               yellow: CGFloat, key: CGFloat) {
        let intent = CGColorRenderingIntent.perceptual
        let cmykColor = self.cgColor.converted(to: CGColorSpaceCreateDeviceCMYK(),
                                               intent: intent, options: nil)
        let cyan: CGFloat = round((cmykColor?.components![0])! * 100)
        let magenta: CGFloat = round((cmykColor?.components![1])! * 100)
        let yellow: CGFloat = round((cmykColor?.components![2])! * 100)
        let key: CGFloat = round((cmykColor?.components![3])! * 100)
        return (cyan, magenta, yellow, key)
    }
}

extension UIColor {
    func colorComponentsByMatchingToGray() -> (gray: CGFloat, alpha: CGFloat)? {
        var grayscale: CGFloat = 0
        var alpha: CGFloat = 0

        if self.getWhite(&grayscale, alpha: &alpha) {
            return (grayscale, alpha)
        } else {
            return nil
        }
    }
}

/// https://gist.github.com/adamgraham/677c0c41901f3eafb441951de9bc914c
/// An extension to provide conversion to and from CIE 1931 XYZ colors.
extension UIColor {

    /// The CIE 1931 XYZ components of a color - luminance (Y) and chromaticity (X,Z).
    struct CIEXYZ: Hashable {

        /// A mix of cone response curves chosen to be orthogonal to luminance and
        /// non-negative, in the range [0, 95.047].
        var XValue: CGFloat
        /// The luminance component of the color, in the range [0, 100].
        var YValue: CGFloat
        /// Somewhat equal to blue, or the "S" cone response, in the range [0, 108.883].
        var ZValue: CGFloat

    }

    /// The CIE 1931 XYZ components of the color.
    var XYZ: CIEXYZ {
        var (redValue, greenValue, blueValue) = (CGFloat(), CGFloat(), CGFloat())
        getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: nil)

        // sRGB (D65) gamma correction - inverse companding to get linear values
        redValue = (redValue > 0.03928) ? pow((redValue + 0.055) / 1.055, 2.4) :
        (redValue / 12.92)
        greenValue = (greenValue > 0.03928) ? pow((greenValue + 0.055) / 1.055, 2.4) :
        (greenValue / 12.92)
        blueValue = (blueValue > 0.03928) ? pow((blueValue + 0.055) / 1.055, 2.4) :
        (blueValue / 12.92)

        // sRGB (D65) matrix transformation
        // http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
        let xThing = (0.4124564 * redValue) + (0.3575761 * greenValue) + (0.1804375 * blueValue)
        let yThing = (0.2126729 * redValue) + (0.7151522 * greenValue) + (0.0721750 * blueValue)
        let zThing = (0.0193339 * redValue) + (0.1191920 * greenValue) + (0.9503041 * blueValue)

        return CIEXYZ(XValue: xThing * 100.0,
                      YValue: yThing * 100.0,
                      ZValue: zThing * 100.0)
    }

    /// Initializes a color from CIE 1931 XYZ components.
    /// - parameter XYZ: The components used to initialize the color.
    /// - parameter alpha: The alpha value of the color.
    convenience init(_ XYZ: CIEXYZ, alpha: CGFloat = 1.0) {
        let xInit = XYZ.XValue / 100.0
        let yInit = XYZ.YValue / 100.0
        let zInit = XYZ.ZValue / 100.0

        // sRGB (D65) matrix transformation
        // http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
        var redInit =  (3.2404542 * xInit) - (1.5371385 * yInit) - (0.4985314 * zInit)
        var greenInit = (-0.9692660 * xInit) + (1.8760108 * yInit) + (0.0415560 * zInit)
        var blueInit =  (0.0556434 * xInit) - (0.2040259 * yInit) + (1.0572252 * zInit)

        // sRGB (D65) gamma correction - companding to get non-linear values
        let kInit: CGFloat = 1.0 / 2.4
        redInit = (redInit <= 0.00304) ? (12.92 * redInit) :
        (1.055 * pow(redInit, kInit) - 0.055)
        greenInit = (greenInit <= 0.00304) ? (12.92 * greenInit) :
        (1.055 * pow(greenInit, kInit) - 0.055)
        blueInit = (blueInit <= 0.00304) ? (12.92 * blueInit) :
        (1.055 * pow(blueInit, kInit) - 0.055)

        self.init(red: redInit, green: greenInit, blue: blueInit, alpha: alpha)
    }

}

// swiftlint:disable identifier_name
/// https://gist.github.com/adamgraham/b2868c72e1d83d432e937bb02b6e27c8
/// An extension to provide conversion to and from CIELAB colors.
extension UIColor {

    /// The CIELAB components of a color - lightness (L) and chromaticity (a,b).
    struct CIELAB: Hashable {

        /// The lightness component of the color, in the range [0, 100] (darkest to brightest).
        var L: CGFloat
        /// The green-red chromaticity component of the color, typically in range [-128, 128].
        var a: CGFloat
        /// The blue-yellow chromaticity component of the color, typically in range [-128, 128].
        var b: CGFloat

    }

    /// A set of constant values used to convert to and from CIELAB colors.
    private struct Constant {

        // swiftlint:disable:next large_tuple
        static let d65: (X: CGFloat, Y: CGFloat, Z: CGFloat) = (95.047, 100.000, 108.883)
        static let ⅓: CGFloat = 1.0 / 3.0
        static let ⁴୵₂₉: CGFloat = 4.0 / 29.0
        static let δ: CGFloat = 6.0 / 29.0
        static let δ³ = δ * δ * δ
        static let δ²3 = δ * δ * 3.0

    }

    /// The CIELAB components of the color using a d65 illuminant and 2° standard observer.
    var Lab: CIELAB {
        func fn(_ t: CGFloat) -> CGFloat {
            if t > Constant.δ³ { return pow(t, Constant.⅓) }
            return (t / Constant.δ²3) + Constant.⁴୵₂₉
        }

        let XYZ = self.XYZ
        let ref = Constant.d65

        let X = fn(XYZ.XValue / ref.X)
        let Y = fn(XYZ.YValue / ref.Y)
        let Z = fn(XYZ.ZValue / ref.Z)

        let L = (116.0 * Y) - 16.0
        let a = 500.0 * (X - Y)
        let b = 200.0 * (Y - Z)

        return CIELAB(L: L, a: a, b: b)
    }

    /// Initializes a color from CIELAB components.
    /// - parameter Lab: The components used to initialize the color.
    /// - parameter alpha: The alpha value of the color.
    convenience init(_ Lab: CIELAB, alpha: CGFloat = 1.0) {
        func fn(_ t: CGFloat) -> CGFloat {
            if t > Constant.δ { return pow(t, 3.0) }
            return Constant.δ²3 * (t - Constant.⁴୵₂₉)
        }

        let ref = Constant.d65

        let L = (Lab.L + 16.0) / 116.0
        let a = L + (Lab.a / 500.0)
        let b = L - (Lab.b / 200.0)

        let X = fn(a) * ref.X
        let Y = fn(L) * ref.Y
        let Z = fn(b) * ref.Z

        self.init(CIEXYZ(XValue: X, YValue: Y, ZValue: Z), alpha: alpha)
    }

}


// template to create more color spaces options
// extension UIColor {
//    func colorComponentsByMatchingTo NAME() -> (cyan: CGFloat, magenta: CGFloat,
//                                               yellow: CGFloat, key: CGFloat) {
//        let intent = CGColorRenderingIntent.perceptual
//        let cmykColor = self.cgColor.converted(to: CGColorSpaceCreateDevice NAME,
//                                               intent: intent, options: nil)
//        let cyan: CGFloat = round((cmykColor?.components![0])! * 100)
//        let magenta: CGFloat = round((cmykColor?.components![1])! * 100)
//        let yellow: CGFloat = round((cmykColor?.components![2])! * 100)
//        let key: CGFloat = round((cmykColor?.components![3])! * 100)
//        return (cyan, magenta, yellow, key)
//    }
// }
// swiftlint:enable identifier_name
