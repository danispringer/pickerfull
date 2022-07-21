//
//  UIViewController+Extensions.swift
//  Prime
//
//  Created by Daniel Springer on 20/06/2018.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit


extension UIViewController {

    // MARK: Alerts

    enum AlertReason {
        case unknown
        case imageSaved
        case permissionDeniedGallery
        case permissiondeniedCamera
        case notice
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
                    alertTitle = "Allow PickerFull access to your Gallery"
                    alertMessage = """
                Access was previously denied. Please grant access from Settings so PickerFull can save your image.
                """
                case .permissiondeniedCamera:
                    alertTitle = "Allow PickerFull access to your Camera"
                    alertMessage = """
            Access was previously denied. Please grant access from Settings to use your Camera from within the app.
            """
                case .notice:
                    alertTitle = "Instructions"
                    alertMessage = """
            HOW TO CLOSE THIS PAGE
            To close this page *preserving* your changes, tap the 'X' at the top right.
            To close this page *discarding* your changes, swipe downwards from the top of it.

            HOW TO EXTRACT FROM IMAGE
            To pick a color from an imported image, tap on the top left pen icon (which will temporarily hide this \
            page), drag the circle over the color you want to extract (you can pinch to zoom in to the image before \
            tapping on the pen icon, to make it easier to get the right spot), lift your finger off the screen, and \
            the picked color will be *temporarily* imported to this page. You may then edit it and - when done - tap \
            on the 'X' to return to the home page of the app, to download/share your color.
            """
                default:
                    alertTitle = "Unknown Error"
                    alertMessage = """
            An unknown error occurred. Please try again
            """
            }

            let alert = UIAlertController(
                title: alertTitle,
                message: alertMessage,
                preferredStyle: alertPreferredStyle)

            let alertAction = UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: nil)
            alert.addAction(alertAction)

            return alert
        }


    // MARK: Helpers

    enum Format {
        case hex
        case rgb
    }


    func rgbFrom(hex: String) -> String {

        var rgbString = ""

        let redString = hex[0...1]
        let greenString = hex[2...3]
        let blueString = hex[4...5]

        rgbString = String(Int(redString, radix: 16)!) +
        ", " +
        String(Int(greenString, radix: 16)!) +
        ", " +
        String(Int(blueString, radix: 16)!)

        return rgbString
    }


    func uiColorFrom(hex: String) -> UIColor {

        let redString = hex[0...1]
        let greenString = hex[2...3]
        let blueString = hex[4...5]

        var myColor: UIColor

        myColor = UIColor(
            red: CGFloat(Int(redString, radix: 16)!) / 255.0,
            green: CGFloat(Int(greenString, radix: 16)!) / 255.0,
            blue: CGFloat(Int(blueString, radix: 16)!) / 255.0,
            alpha: 1.0)


        return myColor
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
