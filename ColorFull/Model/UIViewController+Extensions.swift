//
//  UIViewController+Extensions.swift
//  Prime
//
//  Created by Daniel Springer on 20/06/2018.
//  Copyright © 2021 Daniel Springer. All rights reserved.
//

import UIKit


extension UIViewController {

    // MARK: Alerts

    enum AlertReason {
        case unknown
        case imageSaved
        case permissionDeniedGallery
        case permissiondeniedCamera
    }


    func createAlert(
        alertReasonParam: AlertReason) -> UIAlertController {

            var alertPreferredStyle = UIAlertController.Style.alert

            var alertTitle = ""
            var alertMessage = ""
            switch alertReasonParam {
                case .imageSaved:
                    alertPreferredStyle = UIAlertController.Style.actionSheet
                    alertTitle = "Image Saved"
                    alertMessage = "View your image in your gallery"
                case .permissionDeniedGallery:
                    alertTitle = "Allow ColorFull access to your Gallery"
                    alertMessage = """
                Access was previously denied. Please grant access from Settings so ColorFull can save your image.
                """
                case .permissiondeniedCamera:
                    alertTitle = "Allow ColorFull access to your Camera"
                    alertMessage = """
            Access was previously denied. Please grant access from Settings to use your Camera from within the app.
            """
                default:
                    alertTitle = "Unknown Error"
                    alertMessage = """
            An unknown error occurred. Please try again later, or contact us at dani.springer@icloud.com
            """
            }

            let alert = UIAlertController(
                title: alertTitle,
                message: alertMessage,
                preferredStyle: alertPreferredStyle)

            let alertAction = UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil)
            alert.addAction(alertAction)

            return alert
        }


    // MARK: Helpers

    enum Format {
        case hex
        case rgb
    }

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


    func uiColorFrom(hex: String) -> UIColor {

        let results = isValidHex(hex: hex)

        guard results.isValid else {
            fatalError()
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


    func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let red: CGFloat = components?[0] ?? 0.0
        let green: CGFloat = components?[1] ?? 0.0
        let blue: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "%02lX%02lX%02lX",
                                    lroundf(Float(red * 255)),
                                    lroundf(Float(green * 255)),
                                    lroundf(Float(blue * 255)))
        return hexString
    }


}
