//
//  MakerViewController.swift
//  ColorFull
//
//  Created by Daniel Springer on 06/03/2018.
//  Copyright © 2020 Daniel Springer. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI
import Intents


class MakerViewController: UIViewController,
                           UINavigationControllerDelegate {


    // MARK: Outlets

    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var aboutBarButtonItem: UIBarButtonItem!

    @IBOutlet weak var randomBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var resultView: UIView!


    // MARK: properties

    enum Controls {
        case randomHex
    }

    var currentUIColor: UIColor!
    var currentHexColor: String!

    var hexArrayForRandom: [String] = []

    var hexImage: UIImage!

    var textColor = UIColor.label
    var backgroundColor = UIColor.systemBackground


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        for number in 0...Int(Constants.Values.rgbMax) {
            hexArrayForRandom.append(String(format: Constants.Values.numToHexFormatter, number))
        }

        messageLabel.isHidden = true
        messageLabel.layer.cornerRadius = 20
        messageLabel.layer.masksToBounds = true

        resultView.backgroundColor = uiColorFrom(hex: getSafeHexFromUD())

    }


    // MARK: Helpers

    func getSafeHexFromUD() -> String {
        let hexString: String = UserDefaults.standard.string(forKey: Constants.UserDef.colorKey) ??
            getFallbackColorString()

        return hexString
    }


    func getFallbackColorString() -> String {
        let isDarkModeOn = backgroundColor == UIColor.white
        let fallbackString = isDarkModeOn ? "000000" : "ffffff"

        return fallbackString
    }


    func showApps() {

        let myURL = URL(string: Constants.AppInfo.appsLink)

        guard let safeURL = myURL else {
            let alert = createAlert(alertReasonParam: .unknown)
            if let presenter = alert.popoverPresentationController {
                presenter.barButtonItem = aboutBarButtonItem
            }
                present(alert, animated: true)
            return
        }
            UIApplication.shared.open(safeURL, options: [:], completionHandler: nil)
    }


    // MARK: Update Color

    func updateColor(hexStringParam: String? = nil,
                     rgbArray: [Int] = []) {

        let mySafeString: String = hexStringParam ?? getFallbackColorString()
        self.resultView.backgroundColor = uiColorFrom(hex: mySafeString)

        UserDefaults.standard.set(mySafeString, forKey: Constants.UserDef.colorKey)

    }


    // MARK: Toolbar


    // MARK: Share

    @IBAction func showMainMenu() {

        let mainMenuAlert = UIAlertController(title: "Main Menu", message: nil, preferredStyle: .actionSheet)

        mainMenuAlert.modalPresentationStyle = .popover

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }

        let downloadImageAction = UIAlertAction(title: "Download as Image", style: .default, handler: { _ in

            self.downloadAsImage()
        })


        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.showShareMainMenu()
        }

        let appIconAction = UIAlertAction(title: "Update App Icon", style: .default) { _ in
            self.showUpdateIconMenu()
        }

        let infoAction = UIAlertAction(title: "Contact and Info", style: .default) { _ in
            self.showInfoMainMenu()
        }

        for action in [downloadImageAction, shareAction,
                       appIconAction, infoAction, cancelAction] {
            mainMenuAlert.addAction(action)
        }

        if let presenter = mainMenuAlert.popoverPresentationController {
            presenter.barButtonItem = aboutBarButtonItem
        }

            present(mainMenuAlert, animated: true)
    }

    func showUpdateIconMenu() {
        let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: Constants.StoryboardID.appIconViewController)
            as? AppIconViewController
        if let toPresent = controller {
            self.present(toPresent, animated: true)
        }
    }


    func showShareMainMenu() {
        let shareMainMenuAlert = UIAlertController(title: "Share Menu", message: nil, preferredStyle: .actionSheet)
        shareMainMenuAlert.modalPresentationStyle = .popover

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        }

        let backAction = UIAlertAction(title: "Back to Main Menu", style: .default) { _ in
            self.showMainMenu()
        }

        let shareTextMainAction = UIAlertAction(title: "Share as Text", style: .default) { _ in
            self.showShareTextMenu()
        }

        let shareImageAction = UIAlertAction(title: "Share as Image", style: .default) { _ in
            self.shareAsImage()
        }

        for action in [backAction, shareImageAction, shareTextMainAction, cancelAction] {
            shareMainMenuAlert.addAction(action)
        }

        if let presenter = shareMainMenuAlert.popoverPresentationController {
            presenter.barButtonItem = aboutBarButtonItem
        }
            present(shareMainMenuAlert, animated: true)

    }


    func showShareTextMenu() {
        let shareTextMenuAlert = UIAlertController(
            title: "Share As Text Menu",
            message: nil,
            preferredStyle: .actionSheet)

        shareTextMenuAlert.modalPresentationStyle = .popover

        let shareTextHexAction = UIAlertAction(title: "Share as HEX Text", style: .default) { _ in
            self.shareAsText(format: .hex)
        }

        let shareTextRGBAction = UIAlertAction(title: "Share as RGB Text", style: .default) { _ in
            self.shareAsText(format: .rgb)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        }

        let backAction = UIAlertAction(title: "Back to Share Menu", style: .default) { _ in
            self.showShareMainMenu()
        }

        for action in [backAction, shareTextHexAction, shareTextRGBAction, cancelAction] {
            shareTextMenuAlert.addAction(action)
        }

        if let presenter = shareTextMenuAlert.popoverPresentationController {
            presenter.barButtonItem = aboutBarButtonItem
        }
            present(shareTextMenuAlert, animated: true)
    }


    func showInfoMainMenu() {
        let version: String? = Bundle.main.infoDictionary![Constants.AppInfo.bundleShort] as? String
        let infoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let version = version {
            infoAlert.message = "Version \(version)"
            infoAlert.title = Constants.AppInfo.appName
        }
        infoAlert.modalPresentationStyle = .popover

        let mailAction = UIAlertAction(title: "Contact Us", style: .default) { _ in
            self.launchEmail()
        }

        let reviewAction = UIAlertAction(title: "Leave a Review", style: .default) { _ in
            self.requestReviewManually()
        }

        let shareAppAction = UIAlertAction(title: "Tell a Friend", style: .default) { _ in
            self.shareApp()
        }

        let backAction = UIAlertAction(title: "Back to Main Menu", style: .default) { _ in
            self.showMainMenu()
        }

        let showAppsAction = UIAlertAction(title: Constants.AppInfo.showAppsButtonTitle, style: .default) { _ in
            self.showApps()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        }

        for action in [backAction, mailAction, reviewAction, shareAppAction,
                       showAppsAction, cancelAction] {
            infoAlert.addAction(action)
        }

        if let presenter = infoAlert.popoverPresentationController {
            presenter.barButtonItem = aboutBarButtonItem
        }

            present(infoAlert, animated: true)

    }


    func downloadAsImage() {

        let image = generateImage()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }


    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            let alert = createAlert(alertReasonParam: AlertReason.permissionDenied)
            let goToSettingsButton = UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
                        UIApplication.shared.open(url)

                }

            })
            alert.addAction(goToSettingsButton)
            if let presenter = alert.popoverPresentationController {
                presenter.barButtonItem = aboutBarButtonItem
            }
            present(alert, animated: true)
            return
        }
        let alert = createAlert(alertReasonParam: AlertReason.imageSaved)
        let goToLibraryButton = UIAlertAction(title: "Open Gallery", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: Constants.AppInfo.galleryLink)!)

        })
        alert.addAction(goToLibraryButton)
        if let presenter = alert.popoverPresentationController {
            presenter.barButtonItem = aboutBarButtonItem
        }
            present(alert, animated: true)

    }


    func copyAsImage() {

        let image = generateImage()
        let pasteboard = UIPasteboard.general
        pasteboard.image = image

        let alert = createAlert(alertReasonParam: AlertReason.imageCopied)
        if let presenter = alert.popoverPresentationController {
            presenter.barButtonItem = aboutBarButtonItem
        }
        present(alert, animated: true)

    }


    func shareAsText(format: Format) {

        var myText = ""

        switch format {
        case .hex:
            myText = UserDefaults.standard.string(forKey: Constants.UserDef.colorKey)!
        case .rgb:
            let hexString = UserDefaults.standard.string(forKey: Constants.UserDef.colorKey)

            let redValue = Int(hexString![0...1], radix: 16)!
            let greenValue = Int(hexString![2...3], radix: 16)!
            let blueValue = Int(hexString![4...5], radix: 16)!

            myText = "\(redValue),\(greenValue),\(blueValue)"
        }

        let activityController = UIActivityViewController(activityItems: [myText], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = aboutBarButtonItem
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                if let presenter = alert.popoverPresentationController {
                    presenter.barButtonItem = self.aboutBarButtonItem

                }
                self.present(alert, animated: true)

                return
            }
        }
            present(activityController, animated: true)


    }


    func shareAsImage() {

        let image = generateImage()

        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = aboutBarButtonItem
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                if let presenter = alert.popoverPresentationController {
                    presenter.barButtonItem = self.aboutBarButtonItem
                }
                self.present(alert, animated: true)

                return
            }
        }
            present(activityController, animated: true)

    }


    func generateImage() -> UIImage {

        elementsShould(hide: true)

        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white]
        let jumboAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 40),
            .foregroundColor: UIColor.white]
        let attributedMessagePreHex = NSAttributedString(
            string: "\nHEX\n",
            attributes: regularAttributes)
        let hexString = UserDefaults.standard.string(forKey: Constants.UserDef.colorKey) ?? "<error>"
        let attributedMessageJumboHex = NSAttributedString(string: hexString, attributes: jumboAttributes)
        let attributedMessagePreRGB = NSAttributedString(
            string: "\n\nRGB\n",
            attributes: regularAttributes)

        let redValue = Int(hexString[0...1], radix: 16)!
        let greenValue = Int(hexString[2...3], radix: 16)!
        let blueValue = Int(hexString[4...5], radix: 16)!

        let rgbString = "\(redValue), \(greenValue), \(blueValue)"

        let attributedMessageJumboRGB = NSAttributedString(string: rgbString, attributes: jumboAttributes)

        let attributedMessagePost = NSAttributedString(
            string: Constants.AppInfo.creditMessage,
            attributes: regularAttributes)

        let myAttributedText = NSMutableAttributedString()

        myAttributedText.append(attributedMessagePreHex)
        myAttributedText.append(attributedMessageJumboHex)
        myAttributedText.append(attributedMessagePreRGB)
        myAttributedText.append(attributedMessageJumboRGB)
        myAttributedText.append(attributedMessagePost)

        messageLabel.attributedText = myAttributedText
        let viewColorWas = view.backgroundColor
        view.backgroundColor = UIColor(
            red: CGFloat(Double(redValue)/255),
            green: CGFloat(Double(greenValue)/255),
            blue: CGFloat(Double(blueValue)/255),
            alpha: 1.0)

        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        hexImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        view.backgroundColor = viewColorWas
        elementsShould(hide: false)


        return hexImage
    }


    func elementsShould(hide: Bool) {

        myToolbar.isHidden = hide

        messageLabel.isHidden = !hide

    }


    func shareApp() {

        let message = """
            Create amazing colors. Share with friends. Done.

            Download now:
            https://itunes.apple.com/app/id1410565176
            """
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.modalPresentationStyle = .popover
        activityController.popoverPresentationController?.barButtonItem = aboutBarButtonItem
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                if let presenter = alert.popoverPresentationController {
                    presenter.barButtonItem = self.aboutBarButtonItem
                }
                self.present(alert, animated: true)

                return
            }
        }
        if let presenter = activityController.popoverPresentationController {
            presenter.barButtonItem = aboutBarButtonItem
        }

        present(activityController, animated: true)

    }


    // MARK: Random

    @IBAction func randomPressed(_ sender: Any) {

        let activity = NSUserActivity(activityType: Constants.AppInfo.bundleAndRandom)
        activity.title = "Create Random Color"
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(Constants.AppInfo.bundleAndRandom)
        activity.suggestedInvocationPhrase = "Show Me a Random Color"
        view.userActivity = activity
        activity.becomeCurrent()

        if UserDefaults.standard.bool(forKey: Constants.UserDef.isFirstTapOnRandomButton) {
            // show warning, only continue if user says yes
            let alert = createAlert(alertReasonParam: .firstRandom)
            let okDestructiveAction = UIAlertAction(title: "OK", style: .destructive) { _ in
                self.makeRandomColor()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            for action in [okDestructiveAction, cancelAction] {
                alert.addAction(action)
            }

            UserDefaults.standard.set(false, forKey: Constants.UserDef.isFirstTapOnRandomButton)

            if let presenter = alert.popoverPresentationController {
                presenter.barButtonItem = randomBarButtonItem
            }
            present(alert, animated: true)
        } else {
            makeRandomColor()
        }

    }


    public func makeRandomColor() {
            var randomHex = ""
            let randomRed = hexArrayForRandom.randomElement()!
            let randomGreen = hexArrayForRandom.randomElement()!
            let randomBlue = hexArrayForRandom.randomElement()!

            randomHex = randomRed + randomGreen + randomBlue

            updateColor(hexStringParam: randomHex)
    }


}


extension MakerViewController: MFMailComposeViewControllerDelegate {

    func launchEmail() {

        var emailTitle = Constants.AppInfo.appName
        if let version = Bundle.main.infoDictionary![Constants.AppInfo.bundleShort] {
            emailTitle += " \(version)"
        }

        let messageBody = "Hi. I have a question..."
        let toRecipents = [Constants.AppInfo.email]
        let mailComposer: MFMailComposeViewController = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipents)

            present(mailComposer, animated: true, completion: nil)

    }


    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        var alert = UIAlertController()

        dismiss(animated: true, completion: {
            switch result {
            case MFMailComposeResult.failed:
                alert = self.createAlert(alertReasonParam: AlertReason.messageFailed)
            case MFMailComposeResult.saved:
                alert = self.createAlert(alertReasonParam: AlertReason.messageSaved)
            case MFMailComposeResult.sent:
                alert = self.createAlert(alertReasonParam: AlertReason.messageSent)
            default:
                break
            }
            if alert.title != nil {
                if let presenter = alert.popoverPresentationController {
                    presenter.barButtonItem = self.aboutBarButtonItem
                }
                self.present(alert, animated: true)

            }
        })
    }


}


extension MakerViewController {

    func requestReviewManually() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL

        guard let writeReviewURL = URL(string: Constants.AppInfo.reviewLink)
            else {
                fatalError("Expected a valid URL")
        }

            UIApplication.shared.open(writeReviewURL,
                                      options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
                                      completionHandler: nil)

    }


}


// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(
    _ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in
        (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}


// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}


// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(
    _ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
