//
//  Alert.swift
//  Primes Fun
//
//  Created by Daniel Springer on 20/06/2018.
//  Copyright © 2021 Daniel Springer. All rights reserved.
//

import UIKit


extension UIViewController {


    enum AlertReason {
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
        case .imageSaved:
            alertPreferredStyle = UIAlertController.Style.actionSheet
            alertTitle = NSLocalizedString("Image Saved", comment: "")
            alertMessage = NSLocalizedString("View your image in your gallery", comment: "")
        case .permissionDenied:
            alertTitle = NSLocalizedString("Allow ColorFull access to your gallery", comment: "")
            alertMessage = NSLocalizedString("""
            Access was previously denied. Please grant access from Settings so ColorFull can save your image.
            """, comment: "")
        default:
            alertTitle = NSLocalizedString("Unknown Error", comment: "")
            alertMessage = NSLocalizedString("""
            An unknown error occurred. Please try again later, or contact us at dani.springer@icloud.com
            """, comment: "")
        }

        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: alertPreferredStyle)

        let alertAction = UIAlertAction(
            title: NSLocalizedString("OK", comment: ""),
            style: .default,
            handler: nil)
        alert.addAction(alertAction)

        return alert
    }


}
