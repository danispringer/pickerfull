//
//  Helpers.swift
//  ColorFull
//
//  Created by Daniel Springer on 8/23/19.
//  Copyright © 2020 Dani Springer. All rights reserved.
//


import UIKit


extension UIViewController {

    struct HEXResult {
        let isValid: Bool
        let invalidHexValue: String
        let validHexValue: String
    }

    struct RGBResult {
        let isValid: Bool
        let invalidRgbValue: String
        let validRgbValue: [Int]
    }


    func rgbFrom(hex: String) -> String? {

        let results = isValidHex(hex: hex)

        guard results.isValid else {
            return nil
        }

        var rgbString = ""

        let redString = results.validHexValue[0...1]
        let greenString = results.validHexValue[2...3]
        let blueString = results.validHexValue[4...5]

        rgbString = String(Int(redString, radix: 16)!) +
                    ", " +
                    String(Int(greenString, radix: 16)!) +
                    ", " +
                    String(Int(blueString, radix: 16)!)

        return rgbString
    }


    func uiColorFrom(hex: String) -> UIColor? {

        let results = isValidHex(hex: hex)

        guard results.isValid else {
            return nil
        }

        let redString = results.validHexValue[0...1]
        let greenString = results.validHexValue[2...3]
        let blueString = results.validHexValue[4...5]

        var myColor: UIColor

        myColor = UIColor(
            red: CGFloat(Int(redString, radix: 16)!) / 255.0,
            green: CGFloat(Int(greenString, radix: 16)!) / 255.0,
            blue: CGFloat(Int(blueString, radix: 16)!) / 255.0,
            alpha: 1.0)


        return myColor
    }


    func isValidHex(hex: String) -> HEXResult {
        let uppercasedDirtyHex = hex.uppercased()
        let cleanedHex = uppercasedDirtyHex.filter {
            "ABCDEF0123456789".contains($0)
        }
        guard !(cleanedHex.count < 6) else {
            return HEXResult(isValid: false, invalidHexValue: hex, validHexValue: "")
        }

        let firstSixChars = cleanedHex[0...5]

        return HEXResult(isValid: true, invalidHexValue: "", validHexValue: firstSixChars)
    }


    func isValidRGB(rgb: String) -> RGBResult {

        let cleanedRGB = rgb.filter {
            "0123456789,".contains($0)
        }

        let stringsArray = cleanedRGB.split(separator: ",")
        let intsArray: [Int] = stringsArray.map { Int($0)!}

        guard Array(intsArray).count >= 3 else {
            return RGBResult(isValid: false, invalidRgbValue: rgb, validRgbValue: Array(intsArray))
        }

        let firstThreeValues = Array(intsArray[0...2])

        guard firstThreeValues.allSatisfy({ (0...Int(Constants.Values.rgbMax)).contains($0) }) else {
            return RGBResult(isValid: false, invalidRgbValue: rgb, validRgbValue: firstThreeValues)
        }

        return RGBResult(isValid: true, invalidRgbValue: "", validRgbValue: firstThreeValues)
    }


    // RGB HEX ?
    // RGB UICOLOR ?
    // UICOLOR HEX ?
    // UICOLOR RGB ?

}
