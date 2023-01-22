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


    func getShareMenu(sourceView: UIView) -> UIMenu {

        // MARK: Copy options
        let copyTextHexAction = UIAction(
            title: "Copy as HEX",
            image: UIImage(systemName: "number")) { _ in
                self.copyAsText(format: .hex)
            }
        let copyTextRgbAction = UIAction(
            title: "Copy as RGB",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.copyAsText(format: .rgb)
            }
        let copyTextHSBAction = UIAction(
            title: "Copy as HSB/HSV",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.copyAsText(format: .hsbhsv)
            }
        let copyTextHSLAction = UIAction(
            title: "Copy as HSL",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.copyAsText(format: .hsl)
            }
        let copyTextCMYKAction = UIAction(
            title: "Copy as CMYK",
            image: UIImage(systemName: "printer")) { _ in
                self.copyAsText(format: .cmyk)
            }
        let copyTextGrayAction = UIAction(
            title: "Copy as Grayscale",
            image: UIImage(systemName: "moonphase.full.moon")) { _ in
                self.copyAsText(format: .grayscale)
            }
        let copyTextXYZAction = UIAction(
            title: "Copy as XYZ",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.copyAsText(format: .xyz)
            }
        let copyTextLABAction = UIAction(
            title: "Copy as LAB (CIE)",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.copyAsText(format: .cielab)
            }
        let copyTextFloatAction = UIAction(
            title: "Copy as Float",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.copyAsText(format: .float)
            }

        let copyTextObjcAction = UIAction(
            title: "Copy as Objective-C",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.copyAsText(format: .objc)
            }

        let copyTextSwiftAction = UIAction(
            title: "Copy as Swift",
            image: UIImage(systemName: "swift")) { _ in
                self.copyAsText(format: .swift)
            }

        let copyTextSwiftLiteralAction = UIAction(
            title: "Copy as Swift Literal",
            image: UIImage(systemName: "swift")) { _ in
                self.copyAsText(format: .swiftLiteral)
            }

        let copyTextSwiftUIAction = UIAction(
            title: "Copy as SwiftUI",
            image: UIImage(systemName: "swift")) { _ in
                self.copyAsText(format: .swiftui)
            }

        // MARK: Share options
        let shareTextHexAction = UIAction(
            title: "Share as HEX",
            image: UIImage(systemName: "number")) { _ in
                self.shareAsText(format: .hex, sourceView: sourceView)
            }
        let shareTextRgbAction = UIAction(
            title: "Share as RGB",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.shareAsText(format: .rgb, sourceView: sourceView)
            }
        let shareTextHSBAction = UIAction(
            title: "Share as HSB/HSV",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.shareAsText(format: .hsbhsv, sourceView: sourceView)
            }
        let shareTextHSLAction = UIAction(
            title: "Share as HSL",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.shareAsText(format: .hsl, sourceView: sourceView)
            }
        let shareTextCMYKAction = UIAction(
            title: "Share as CMYK",
            image: UIImage(systemName: "printer")) { _ in
                self.shareAsText(format: .cmyk, sourceView: sourceView)
            }
        let shareTextGrayAction = UIAction(
            title: "Share as Grayscale",
            image: UIImage(systemName: "moonphase.full.moon")) { _ in
                self.shareAsText(format: .grayscale, sourceView: sourceView)
            }
        let shareTextXYZAction = UIAction(
            title: "Share as XYZ",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.shareAsText(format: .xyz, sourceView: sourceView)
            }
        let shareTextLABAction = UIAction(
            title: "Share as LAB (CIE)",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.shareAsText(format: .cielab, sourceView: sourceView)
            }
        let shareTextFloatAction = UIAction(
            title: "Share as Float",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.shareAsText(format: .float, sourceView: sourceView)
            }

        let shareTextObjcAction = UIAction(
            title: "Share as Objective-C",
            image: UIImage(systemName: "eyedropper.halffull")) { _ in
                self.shareAsText(format: .objc, sourceView: sourceView)
            }

        let shareTextSwiftAction = UIAction(
            title: "Share as Swift",
            image: UIImage(systemName: "swift")) { _ in
                self.shareAsText(format: .swift, sourceView: sourceView)
            }

        let shareTextSwiftLiteralAction = UIAction(
            title: "Share as Swift Literal",
            image: UIImage(systemName: "swift")) { _ in
                self.shareAsText(format: .swiftLiteral, sourceView: sourceView)
            }

        let shareTextSwiftUIAction = UIAction(
            title: "Share as SwiftUI",
            image: UIImage(systemName: "swift")) { _ in
                self.shareAsText(format: .swiftui, sourceView: sourceView)
            }

        let shareMenu = UIMenu(options: .displayInline, children: [
            shareTextSwiftUIAction,
            shareTextSwiftLiteralAction,
            shareTextSwiftAction,
            shareTextObjcAction,
            shareTextFloatAction,
            shareTextLABAction,
            shareTextXYZAction,
            shareTextGrayAction,
            shareTextCMYKAction,
            shareTextHSLAction,
            shareTextHSBAction,
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
            copyTextLABAction,
            copyTextXYZAction,
            copyTextGrayAction,
            copyTextCMYKAction,
            copyTextHSLAction,
            copyTextHSBAction,
            copyTextRgbAction,
            copyTextHexAction])
        return shareAndCopyMenu
    }


    func copyAsText(format: ExportFormat) {
        var myText = ""
        myText = hexTo(format: format)
        UIPasteboard.general.string = myText
    }


    func shareAsText(format: ExportFormat, sourceView: UIView) {
        var myText = ""
        myText = hexTo(format: format)
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
        savedColors = savedColors.uniqued()

        guard !savedColors.contains(color) else {
            return
        }

        savedColors.append(color)

        saveToDocs(text: savedColors.joined(separator: ","),
                   withFileName: filename)
    }


    // MARK: Helpers

    enum ExportFormat: CaseIterable {
        case hex
        case rgb
        case hsbhsv
        case hsl
        case cmyk
        case grayscale
        case xyz
        case cielab
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


    func hexTo(format: ExportFormat) -> String {

        let hex = getSafeHexFromUD()

        switch format {
            case .cielab:
                let someUIColor = uiColorFrom(hex: hex)
                let someLabColor = someUIColor.Lab
                let roundedL = round(someLabColor.L * 1000) / 1000
                let roundedA = round(someLabColor.a * 1000) / 1000
                let roundedB = round(someLabColor.b * 1000) / 1000
                return """
                Lab(\(roundedL), \(roundedA), \(roundedB))
                """
            case .xyz:
                let someUIColor = uiColorFrom(hex: hex)
                let someXYZColor = someUIColor.XYZ
                let roundedX = round(someXYZColor.XValue * 1000) / 1000
                let roundedY = round(someXYZColor.YValue * 1000) / 1000
                let roundedZ = round(someXYZColor.ZValue * 1000) / 1000
                return """
                xyz(\(roundedX), \(roundedY), \(roundedZ))
                """
            case .grayscale:
                let someUIColor = uiColorFrom(hex: hex)
                let someGray = someUIColor.colorComponentsByMatchingToGray()
                guard let safeGray = someGray?.gray else {
                    return "error. please let us know."
                }
                let roundedGray = round(safeGray * 1000) / 1000

                return "gray(\(roundedGray))"
            case .cmyk:
                let someUIColor = uiColorFrom(hex: hex)
                let someCMYK = someUIColor.colorComponentsByMatchingToCMYK()
                let roundedCyan = round(someCMYK.cyan * 1000) / 1000
                let roundedMagenta = round(someCMYK.magenta * 1000) / 1000
                let roundedYellow = round(someCMYK.yellow * 1000) / 1000
                let roundedKey = round(someCMYK.key * 1000) / 1000
                return """
                cmyk(\(roundedCyan), \(roundedMagenta), \(roundedYellow), \(roundedKey))
                """
            case .hsl:
                let someUIColor = uiColorFrom(hex: hex)
                let someHSL = someUIColor.hsl
                let roundedHue = round(someHSL.hue * 10) / 10.0
                let roundedSaturation = round(someHSL.saturation * 10) / 10.0
                let roundedLightness = round(someHSL.lightness * 10) / 10.0
                return """
                hsl(\(roundedHue), \(roundedSaturation), \(roundedLightness))
                """
            case .hsbhsv:
                var hue: CGFloat = 0
                var saturation: CGFloat = 0
                var brightness: CGFloat = 0
                var alpha: CGFloat = 0
                let couldBeConverted = uiColorFrom(hex: hex)
                    .getHue(&hue, saturation: &saturation,
                            brightness: &brightness, alpha: &alpha)
                if couldBeConverted {
                    let roundedHue = round(hue * 1000) / 1000.0
                    let roundedSaturation = round(saturation * 1000) / 1000.0
                    let roundedBrightness = round(brightness * 1000) / 1000.0
                    let roundedAlpha = round(alpha * 1000) / 1000.0
                    return """
                    hsb(\(roundedHue), \(roundedSaturation), \(roundedBrightness), \
                    \(roundedAlpha))
                    """
                    // The color is in a compatible color space, and the variables
                    // `hue`, `saturation`, `brightness`, and `alpha` have been
                    // changed to contain these values.
                } else {
                    return "Error. Please let us know."
                }
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
            case .hex:
                return "#\(hex)"
            case .float:
                var floatString = ""
                let redString = hex[0...1]
                let greenString = hex[2...3]
                let blueString = hex[4...5]
                floatString = "float(" +
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
            var myArray = savedString.components(separatedBy: ",")
            if myArray.isEmpty {
                return nil
            } else {
                if myArray.count == 1 && myArray.first == "" {
                    return nil
                }
                myArray = myArray.uniqued()
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
