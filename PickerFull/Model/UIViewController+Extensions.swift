//
//  UIViewController+Extensions.swift
//  Prime
//
//  Created by Daniel Springer on 20/06/2018.
//  Copyright © 2023 Daniel Springer. All rights reserved.
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


    func getShareOrSaveMenu(sourceView: UIView, hexString: String?) -> UIMenu {

        var safeHexString = ""

        if hexString == nil {
            safeHexString = getSafeHexFromUD()
        } else {
            safeHexString = hexString!
        }

        // MARK: Copy options
        let copyTextHexAction = UIAction(
            title: "Copy as HEX",
            image: UIImage(systemName: "number")) { _ in
                self.copyAsText(format: .hex, hexString: safeHexString)
            }
        let copyTextRgbAction = UIAction(
            title: "Copy as RGB",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.copyAsText(format: .rgb, hexString: safeHexString)
            }
        let copyTextFloatAction = UIAction(
            title: "Copy as Float",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.copyAsText(format: .float, hexString: safeHexString)
            }

        let copyTextObjcAction = UIAction(
            title: "Copy as Objective-C",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.copyAsText(format: .objc, hexString: safeHexString)
            }

        let copyTextSwiftAction = UIAction(
            title: "Copy as Swift",
            image: UIImage(systemName: "swift")) { _ in
                self.copyAsText(format: .swift, hexString: safeHexString)
            }

        let copyTextSwiftLiteralAction = UIAction(
            title: "Copy as Swift Literal",
            image: UIImage(systemName: "swift")) { _ in
                self.copyAsText(format: .swiftLiteral, hexString: safeHexString)
            }

        let copyTextSwiftUIAction = UIAction(
            title: "Copy as SwiftUI",
            image: UIImage(systemName: "swift")) { _ in
                self.copyAsText(format: .swiftui, hexString: safeHexString)
            }

        // MARK: Share options
        let shareTextHexAction = UIAction(
            title: "Share as HEX",
            image: UIImage(systemName: "number")) { _ in
                self.shareAsText(format: .hex, sourceView: sourceView, hexString: safeHexString)
            }
        let shareTextRgbAction = UIAction(
            title: "Share as RGB",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.shareAsText(format: .rgb, sourceView: sourceView, hexString: safeHexString)
            }
        let shareTextFloatAction = UIAction(
            title: "Share as Float",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.shareAsText(format: .float, sourceView: sourceView,
                                 hexString: safeHexString)
            }

        let shareTextObjcAction = UIAction(
            title: "Share as Objective-C",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.shareAsText(format: .objc, sourceView: sourceView,
                                 hexString: safeHexString)
            }

        let shareTextSwiftAction = UIAction(
            title: "Share as Swift",
            image: UIImage(systemName: "swift")) { _ in
                self.shareAsText(format: .swift, sourceView: sourceView,
                                 hexString: safeHexString)
            }

        let shareTextSwiftLiteralAction = UIAction(
            title: "Share as Swift Literal",
            image: UIImage(systemName: "swift")) { _ in
                self.shareAsText(format: .swiftLiteral, sourceView: sourceView,
                                 hexString: safeHexString)
            }

        let shareTextSwiftUIAction = UIAction(
            title: "Share as SwiftUI",
            image: UIImage(systemName: "swift")) { _ in
                self.shareAsText(format: .swiftui, sourceView: sourceView,
                                 hexString: safeHexString)
            }

        let shareMenu = UIMenu(options: .displayInline, children: [
            shareTextSwiftUIAction,
            shareTextSwiftLiteralAction,
            shareTextSwiftAction,
            shareTextObjcAction,
            shareTextFloatAction,
            shareTextRgbAction,
            shareTextHexAction
        ])

        let shareAndCopyMenu = UIMenu(options: .displayInline, children: [
            shareMenu,
            copyTextSwiftUIAction,
            copyTextSwiftLiteralAction,
            copyTextSwiftAction,
            copyTextObjcAction,
            copyTextFloatAction,
            copyTextRgbAction,
            copyTextHexAction])
        return shareAndCopyMenu
    }


    func copyAsText(format: ExportFormat, hexString: String) {
        var myText = ""
        myText = hexTo(format: format, hex: hexString)
        UIPasteboard.general.string = myText
    }


    func shareAsText(format: ExportFormat, sourceView: UIView, hexString: String) {
        var myText = ""
        myText = hexTo(format: format, hex: hexString)
        share(string: myText, sourceView: sourceView)
    }


    func share(string: String, sourceView: UIView) {

        let message = string

        let activityController = UIActivityViewController(activityItems: [message],
                                                          applicationActivities: nil)
        activityController.modalPresentationStyle = .popover
        activityController.popoverPresentationController?.sourceView = sourceView
        activityController
            .completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
                guard error == nil else {
                    let alert = self.createAlert(alertReasonParam: AlertReason.unknown,
                                                 okMessage: Const.AppInfo.okMessage)
                    if let presenter = alert.popoverPresentationController {
                        presenter.sourceView = sourceView
                    }
                    DispatchQueue.main.async {
                        self.present(alert, animated: true)
                    }

                    return
                }
            }
        if let presenter = activityController.popoverPresentationController {
            presenter.sourceView = sourceView
        }

        DispatchQueue.main.async {
            self.present(activityController, animated: true)
        }

    }


    func getSafeHexFromUD() -> String {
        let hexString: String = UD.string(forKey: Const.UserDef.colorKey)!
        return hexString
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
                alertTitle = "Allow app access to your Gallery"
                alertMessage = """
                Access was previously denied. Please grant access from Settings to save \
                your image.
                """
            case .permissiondeniedCamera:
                alertTitle = "Allow app access to your Camera"
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


    func saveToFiles(color: String, filename: String) {

        var savedColors: [String] = readFromDocs(
            withFileName: filename) ?? []

        savedColors.append(color)

        saveToDocs(text: savedColors.joined(separator: ","),
                   withFileName: filename)
    }


    // MARK: Helpers

    enum ExportFormat {
        case hex
        case rgb
        case rgbTable
        case float
        case objc
        case swift
        case swiftLiteral
        case swiftui
    }


    private func aHexToRGB(hex: String) -> String {
        return String(Int(hex, radix: 16)!)
    }


    private func aHexToFloat(hex: String) -> String {
        let aInt = Int(hex, radix: 16)!
        let aFloat = Double(aInt) / 255.0
        let aRounded = (aFloat * 1000).rounded(.toNearestOrEven) / 1000
        return "\(aRounded)"
    }


    func hexTo(format: ExportFormat, hex: String) -> String {

        switch format {
            case .rgb:
                var rgbString = ""
                let redString = hex[0...1]
                let greenString = hex[2...3]
                let blueString = hex[4...5]
                rgbString = "rgb(" +
                aHexToRGB(hex: redString) +
                ", " +
                aHexToRGB(hex: greenString) +
                ", " +
                aHexToRGB(hex: blueString) +
                ")"
                return rgbString
            case .rgbTable:
                var rgbString = ""
                let redString = hex[0...1]
                let greenString = hex[2...3]
                let blueString = hex[4...5]
                rgbString = aHexToRGB(hex: redString) +
                ", " +
                aHexToRGB(hex: greenString) +
                ", " +
                aHexToRGB(hex: blueString)
                return rgbString
            case .hex:
                return "#\(hex)"
            case .float:
                var floatString = ""
                let redString = hex[0...1]
                let greenString = hex[2...3]
                let blueString = hex[4...5]
                floatString = "(" +
                aHexToFloat(hex: redString) +
                ", " +
                aHexToFloat(hex: greenString) +
                ", " +
                aHexToFloat(hex: blueString) +
                ")"
                return floatString
            case .objc:
                var objcString = ""
                let redString = hex[0...1]
                let greenString = hex[2...3]
                let blueString = hex[4...5]
                objcString = "[UIColor colorWithRed: " + aHexToFloat(hex: redString) +
                " green: " + aHexToFloat(hex: greenString) +
                " blue: " + aHexToFloat(hex: blueString) +
                " alpha: 1.000]"
                return objcString
            case .swift:
                var swiftString = ""
                let redString = hex[0...1]
                let greenString = hex[2...3]
                let blueString = hex[4...5]
                swiftString = "UIColor(red: " + aHexToFloat(hex: redString) +
                ", green: " + aHexToFloat(hex: greenString) +
                ", blue: " + aHexToFloat(hex: blueString) +
                ", alpha: 1.000)"
                return swiftString
            case .swiftLiteral:
                var swiftLiteralString = ""
                let redString = hex[0...1]
                let greenString = hex[2...3]
                let blueString = hex[4...5]
                swiftLiteralString = "#colorLiteral(red: " + aHexToFloat(hex: redString) +
                ", green: " + aHexToFloat(hex: greenString) +
                ", blue: " + aHexToFloat(hex: blueString) +
                ", alpha: 1.000)"
                return swiftLiteralString
            case .swiftui:
                var swiftUIString = ""
                let redString = hex[0...1]
                let greenString = hex[2...3]
                let blueString = hex[4...5]
                swiftUIString = "Color(red: " + aHexToFloat(hex: redString) +
                ", green: " + aHexToFloat(hex: greenString) +
                ", blue: " + aHexToFloat(hex: blueString) +
                ", opacity: 1.000)"
                return swiftUIString
        }

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


    func readFromDocs(withFileName fileName: String) -> [String]? {
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
    }


}
