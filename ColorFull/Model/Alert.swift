//
//  Alert.swift
//  Primes Fun
//
//  Created by Daniel Springer on 20/06/2018.
//  Copyright © 2020 Daniel Springer. All rights reserved.
//

import UIKit


extension UIViewController {


    enum AlertReason {
        case messageSaved
        case messageFailed
        case messageSent
        case unknown
        case imageSaved
        case permissionDenied
    }


    enum Format {
        case hex
        case rgb
    }


    func createAlert(
        alertReasonParam: AlertReason,
        invalidCode: String = "",
        format: Format = .hex) -> UIAlertController {

        var alertPreferredStyle = UIAlertController.Style.alert

        var alertTitle = ""
        var alertMessage = ""
        switch alertReasonParam {
        case .messageSaved:
            alertPreferredStyle = UIAlertController.Style.actionSheet
            alertTitle = "Message saved"
            alertMessage = "Your message has been saved to drafts."
        case .messageFailed:
            alertTitle = "Action failed"
            alertMessage = """
            Your message has not been sent. Please try again, or contact us: musicbyds@icloud.com
            """
        case .messageSent:
            alertPreferredStyle = UIAlertController.Style.actionSheet
            alertTitle = "Success!"
            alertMessage = "Your message has been sent. You should hear from us within 24 hours."
        case .imageSaved:
            alertPreferredStyle = UIAlertController.Style.actionSheet
            alertTitle = "Success!"
            alertMessage = "Your image has been saved to your library."
        case .permissionDenied:
            alertTitle = "Allow ColorFull access to your gallery"
            alertMessage = """
            Access was previously denied. Please grant access from Settings so ColorFull can save your image.
            """
        default:
            alertTitle = "Unknown Error"
            alertMessage = """
            An unknown error occurred. Please try again later, or contact us at musicbyds@icloud.com
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


}
