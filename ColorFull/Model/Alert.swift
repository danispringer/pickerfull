//
//  Alert.swift
//  Primes Fun
//
//  Created by Daniel Springer on 20/06/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit


extension UIViewController {


    enum AlertReason {
        case network
        case messageSaved
        case messageFailed
        case messageSent
        case unknown
        case imageSaved
        case textCopied
        case imageCopied
        case permissionDenied
        case emptyPasteHex
        case emptyPasteRGB
        case invalidHex
        case invalidRGB
        case hexPasted
        case RGBPasted
        case firstRandom
    }


    enum Format {
        case hex
        case rgb
    }


    func createAlert(alertReasonParam: AlertReason, invalidCode: String = "",
                     format: Format = .hex) -> UIAlertController {

        var addOkButton = true

        var alertTitle = ""
        var alertMessage = ""
        switch alertReasonParam {
        case .network:
            alertTitle = "Network error"
            alertMessage = "Please check your network connection and try again."
        case .messageSaved:
            alertTitle = "Message saved"
            alertMessage = "Your message has been saved to drafts."
        case .messageFailed:
            alertTitle = "Action failed"
            alertMessage = """
            Your message has not been sent. Please try again later, or contact us by leaving a review.
            """
        case .messageSent:
            alertTitle = "Success!"
            alertMessage = "Your message has been sent. You should hear from us within 24 hours."
        case .imageSaved:
            alertTitle = "Success!"
            alertMessage = "Your image has been saved to your library."
        case .textCopied:
            alertTitle = "Success!"
            alertMessage = """
            Your color has been copied as text in \(format) format.\nDon't forget to paste \
            it somewhere!
            """
        case .imageCopied:
            alertTitle = "Success!"
            alertMessage = "Your image has been copied.\nDon't forget to paste it somewhere!"
        case .permissionDenied:
            alertTitle = "Allow ColorFull access to your gallery"
            alertMessage = """
            Access was previously denied. Please grant access from Settings so ColorFull can save your image.
            """
        case .invalidHex:
            alertTitle = "Invalid HEX"
            alertMessage = "The pasted text\n\"\(invalidCode)\"\nis not a valid HEX."
        case .emptyPasteHex:
            alertTitle = "Pasteboard empty"
            alertMessage = "There's nothing to paste. Please copy a HEX code and try again."
        case .hexPasted:
            alertTitle = "Success!"
            alertMessage = "The app's sliders and spinners have been updated with your pasted HEX code."
        case .invalidRGB:
            alertTitle = "Invalid RGB"
            alertMessage = """
            The pasted text\n\"\(invalidCode)\"\nis not a valid RGB.\nPaste numbers only, \
            separated by commas.\nFor example: 255,12,90
            """
        case .emptyPasteRGB:
            alertTitle = "Pasteboard emtpy"
            alertMessage = "There's nothing to paste. Please copy a RGB code and try again."
        case .RGBPasted:
            alertTitle = "Success!"
            alertMessage = "The app's sliders and spinners have been updated with your pasted HEX code."
        case .firstRandom:
            addOkButton = false
            alertTitle = "Replacing Color"
            alertMessage = """
            This magical button generates a new random color, which will replace your current one \
            (#\(UserDefaults.standard.string(forKey: Constants.UserDef.colorKey) ?? "NO COLOR FOUND")).
            If you would like to save your current color first:
            - Tap "Cancel"
            - Save your color (using the "About" button on the top right of your screen)
            - Then tap this magical button again.
            This message will only be shown once. Future taps will immediately replace the current color.
            """

        default:
            alertTitle = "Unknown Error"
            alertMessage = """
            An unknown error occurred. Please try again later, or contact us at musicbyds@icloud.com
            """
        }

        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        if addOkButton {
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)
        }

        return alert
    }


}
