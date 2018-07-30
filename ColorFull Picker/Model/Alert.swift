//
//  Alert.swift
//  Primes Fun
//
//  Created by Dani Springer on 20/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    enum alertReason: String {
        case textfieldEmpty = "textfieldEmpty"
        case network = "network"
        case messageSaved = "messageSaved"
        case messageFailed = "messageFailed"
        case messageSent = "messageSent"
        case unknown = "unknown"
        case maxChars = "maxChars"
    }
    
    func createAlert(alertReasonParam: String) -> UIAlertController {
        
        var alertTitle = ""
        var alertMessage = ""
        switch alertReasonParam {
        case alertReason.network.rawValue:
            alertTitle = "Network error"
            alertMessage = "Please check your network connection and try again."
        case alertReason.textfieldEmpty.rawValue:
            alertTitle = "Oops"
            alertMessage = "Textfield is empty. Please enter a number and try again."

        case alertReason.messageSaved.rawValue:
            alertTitle = "Message saved"
            alertMessage = "Your message has been saved to drafts."
        case alertReason.messageFailed.rawValue:
            alertTitle = "Action failed"
            alertMessage = "Your message has not been sent. Please try again later, or contact us by visiting DaniSpringer.GitHub.io"
        case alertReason.messageSent.rawValue:
            alertTitle = "Success!"
            alertMessage = "Your message has been sent. You should hear from us within 24 working hours."
        default:
            alertTitle = "Unknown error"
            alertMessage = "An unknown error occurred. Please try again later, or contact us by visiting DaniSpringer.GitHub.io"
        }
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        
        return alert
    }
}
