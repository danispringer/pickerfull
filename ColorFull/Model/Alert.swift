//
//  Alert.swift
//  Primes Fun
//
//  Created by Daniel Springer on 20/06/2018.
//  Copyright © 2018 Daniel Springer. All rights reserved.
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
    }


    enum Format {
        case hex
        case rgb
    }


    func createAlert(alertReasonParam: AlertReason, invalidCode: String = "",
                     format: Format = .hex) -> UIAlertController {

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
            alertMessage = "Your message has been sent. You should hear from us within 24 working hours."
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
            alertTitle = "Permission denied"
            alertMessage = """
            ColorFull needs access to your gallery in order to save your image. \
            Please allow access in Settings.
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

        default:
            alertTitle = "Unknown error"
            alertMessage = """
            An unknown error occurred. Please try again later, or contact us by leaving a review.
            """
        }

        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)

        return alert
    }

    
}
