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
        case permissionDeniedGallery
        case permissiondeniedCamera
        case deleteHistory
        case imageSaved
        case xSaves
        case emailError
    }


    func createAlert(alertReasonParam: AlertReason, okMessage: String) -> UIAlertController {

        var alertTitle = ""
        var alertMessage = ""
        switch alertReasonParam {
            case .emailError:
                alertTitle = "Email Not Sent"
                alertMessage = """
                Your device could not send e-mail. Please check e-mail configuration and \
                try again.
                """
            case .xSaves:
                alertTitle = "Important"
                alertMessage = """
                You can close this page in two ways:

                Tapping on 'X' will SAVE the selected color to the app home screen.

                Dragging the page to the bottom of the screen will DISCARD the selection.
                """
            case .permissionDeniedGallery:
                alertTitle = "Allow PickerFull access to your Gallery"
                alertMessage = """
                Access was previously denied. Please grant access from Settings so\
                PickerFull can save your image.
                """
            case .permissiondeniedCamera:
                alertTitle = "Allow PickerFull access to your Camera"
                alertMessage = """
            Access was previously denied. Please grant access from Settings to use your\
            Camera from within the app.
            """
            case .deleteHistory:
                alertTitle = "Delete All History?"
                alertMessage = "Are you sure you want to delete all of Random History?"
            case .imageSaved:
                alertTitle = "Image Saved"
                alertMessage = "You can view it in your Photos app"
            default:
                alertTitle = "Unknown Error"
                alertMessage = """
            An unknown error occurred. Please try again
            """
        }

        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert)

        let alertAction = UIAlertAction(
            title: okMessage,
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


    private func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true)
        return documentDirectory[0]
    }


    private func append(toPath path: String,
                        withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)

            return pathURL.absoluteString
        }

        return nil
    }

    func readFromDocs(fromDocumentsWithFileName fileName: String) -> [String]? {
        guard let filePath = self.append(toPath: self.documentDirectory(),
                                         withPathComponent: fileName) else {
            return nil
        }
        do {
            let savedString = try String(contentsOfFile: filePath)
            let myArray = savedString.components(separatedBy: ",")
            if myArray.isEmpty {
                return nil
            } else {
                if myArray.count == 1 && myArray.first == "" {
                    return nil
                }
                return myArray
            }
        } catch {
            // print("Error reading saved file")
            return nil
        }
    }


    func saveToDocs(text: String,
                    withFileName fileName: String) {
        guard let filePath = self.append(toPath: documentDirectory(),
                                         withPathComponent: fileName) else {
            return
        }

        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error", error)
            return
        }

        // print("Save successful")
    }

}
