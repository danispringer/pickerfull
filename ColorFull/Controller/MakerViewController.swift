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
                           UINavigationControllerDelegate, UIColorPickerViewControllerDelegate {


    // MARK: Outlets

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var downloadButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!


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

    let colorPicker = UIColorPickerViewController()


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        for number in 0...Int(Const.Values.rgbMax) {
            hexArrayForRandom.append(String(format: Const.Values.numToHexFormatter, number))
        }

        messageLabel.isHidden = true
        messageLabel.layer.cornerRadius = 20
        messageLabel.layer.masksToBounds = true
        let selectedColor: UIColor = uiColorFrom(hex: getSafeHexFromUD()) ?? getFallbackColor()

        resultView.backgroundColor = selectedColor

        myToolbar.layer.cornerRadius = myToolbar.bounds.height * 0.5
        myToolbar.layer.masksToBounds = true

        colorPicker.delegate = self
        colorPicker.supportsAlpha = false
        colorPicker.selectedColor = selectedColor
        colorPicker.title = "ColorFull: Your Color Awaits"

        menuButton.menu = getMainMenu()
        shareButton.menu = getShareMenu()

    }


    // MARK: Helpers

    func getSafeHexFromUD() -> String {
        let hexString: String = UserDefaults.standard.string(forKey: Const.UserDef.colorKey) ??
            getFallbackColorString()

        return hexString
    }


    func getFallbackColorString() -> String {
        let isDarkModeOn = backgroundColor == UIColor.white
        let fallbackString = isDarkModeOn ? "000000" : "ffffff"

        return fallbackString
    }


    func getFallbackColor() -> UIColor {
        let isDarkModeOn = backgroundColor == UIColor.white
        let fallbackColor = isDarkModeOn ? UIColor.black : UIColor.white

        return fallbackColor
    }


    func showApps() {

        let myURL = URL(string: Const.AppInfo.appsLink)

        guard let safeURL = myURL else {
            let alert = createAlert(alertReasonParam: .unknown)
            if let presenter = alert.popoverPresentationController {
                presenter.barButtonItem = menuButton
            }
                present(alert, animated: true)
            return
        }
            UIApplication.shared.open(safeURL, options: [:], completionHandler: nil)
    }


    // MARK: Update Color

    func updateColor(hexStringParam: String? = nil) {

        let mySafeString: String = hexStringParam ?? getFallbackColorString()
        let selectedColor: UIColor = uiColorFrom(hex: mySafeString) ?? getFallbackColor()
        self.resultView.backgroundColor = selectedColor
        colorPicker.selectedColor = selectedColor

        UserDefaults.standard.set(mySafeString, forKey: Const.UserDef.colorKey)

    }


    // MARK: Toolbar


    // MARK: Share

    func getMainMenu() -> UIMenu {

        let version: String? = Bundle.main.infoDictionary![Const.AppInfo.bundleShort] as? String

        let shareApp = UIAction(title: Const.AppInfo.shareApp, image: UIImage(systemName: "heart"),
                                state: .off) { _ in
            self.shareApp()
        }
        let contact = UIAction(title: Const.AppInfo.sendFeedback, image: UIImage(systemName: "envelope"),
                               state: .off) { _ in
            self.launchEmail()
        }
        let review = UIAction(title: Const.AppInfo.leaveReview,
                              image: UIImage(systemName: "hand.thumbsup"), state: .off) { _ in
            self.requestReviewManually()
        }
        let moreApps = UIAction(title: Const.AppInfo.showAppsButtonTitle, image: UIImage(systemName: "apps.iphone"),
                                state: .off) { _ in
            self.showApps()
        }
        let settings = UIAction(title: Const.AppInfo.settings,
                                  image: UIImage(systemName: "gearshape"), state: .off) { _ in
            self.settingsVC()
        }

        var myTitle = Const.AppInfo.appName
        if let safeVersion = version {
            myTitle += " \(Const.AppInfo.version) \(safeVersion)"
        }

        let aboutMenu = UIMenu(title: myTitle, image: nil, options: .displayInline,
                              children: [settings, contact, review, shareApp, moreApps])
        return aboutMenu
    }


    func settingsVC() {
        let storyboard = UIStoryboard(name: Const.StoryboardIDIB.main, bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: Const.StoryboardIDIB.appIconViewController)
            as? AppIconViewController
        if let toPresent = controller {
            self.present(toPresent, animated: true)
        }
    }


    func getShareMenu() -> UIMenu {

        let shareTextHexAction = UIAction(title: "Share color as HEX text", image: UIImage(systemName: "heart")) { _ in
            self.shareAsText(format: .hex)
        }

        let shareTextRGBAction = UIAction(title: "Share color as RGB text", image: UIImage(systemName: "heart")) { _ in
            self.shareAsText(format: .rgb)
        }

        let shareImageAction = UIAction(title: "Share color as image", image: UIImage(systemName: "heart")) { _ in
            self.shareAsImage()
        }

        let shareMenu = UIMenu(options: .displayInline, children: [shareTextHexAction, shareTextRGBAction, shareImageAction])

        return shareMenu

    }


    @IBAction func downloadAsImage() {
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
                presenter.barButtonItem = downloadButton
            }
            present(alert, animated: true)
            return
        }
        let alert = createAlert(alertReasonParam: AlertReason.imageSaved)
        let openLibraryButton = UIAlertAction(title: "View Your Image", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: Const.AppInfo.galleryLink)!)

        })
        alert.addAction(openLibraryButton)
        if let presenter = alert.popoverPresentationController {
            presenter.barButtonItem = downloadButton
        }
            present(alert, animated: true)
    }


    func shareAsText(format: Format) {
        var myText = ""
        switch format {
        case .hex:
            myText = UserDefaults.standard.string(forKey: Const.UserDef.colorKey)!
        case .rgb:
            let hexString = UserDefaults.standard.string(forKey: Const.UserDef.colorKey)

            let redValue = Int(hexString![0...1], radix: 16)!
            let greenValue = Int(hexString![2...3], radix: 16)!
            let blueValue = Int(hexString![4...5], radix: 16)!

            myText = "\(redValue),\(greenValue),\(blueValue)"
        }

        let activityController = UIActivityViewController(activityItems: [myText], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = menuButton
        activityController.completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                if let presenter = alert.popoverPresentationController {
                    presenter.barButtonItem = self.shareButton

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
        activityController.popoverPresentationController?.barButtonItem = menuButton
        activityController.completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                if let presenter = alert.popoverPresentationController {
                    presenter.barButtonItem = self.shareButton
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
        let hexString = getSafeHexFromUD()
        let attributedMessageJumboHex = NSAttributedString(string: hexString, attributes: jumboAttributes)
        let attributedMessagePreRGB = NSAttributedString(
            string: "\n\nRGB\n",
            attributes: regularAttributes)

        let rgbString: String = rgbFrom(hex: hexString)!
        let myUIColor = uiColorFrom(hex: hexString)

        let attributedMessageJumboRGB = NSAttributedString(string: rgbString, attributes: jumboAttributes)

        let attributedMessagePost = NSAttributedString(
            string: Const.AppInfo.creditMessage,
            attributes: regularAttributes)

        let myAttributedText = NSMutableAttributedString()

        myAttributedText.append(attributedMessagePreHex)
        myAttributedText.append(attributedMessageJumboHex)
        myAttributedText.append(attributedMessagePreRGB)
        myAttributedText.append(attributedMessageJumboRGB)
        myAttributedText.append(attributedMessagePost)

        messageLabel.attributedText = myAttributedText
        let viewColorWas = view.backgroundColor
        view.backgroundColor = myUIColor

        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        hexImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        view.backgroundColor = viewColorWas
        elementsShould(hide: false)


        return hexImage
    }


    func elementsShould(hide: Bool) {

        messageLabel.isHidden = !hide

        myToolbar.isHidden = hide

    }


    func shareApp() {

        let message = """
            We believe life should be ColorFull. Do you?
            https://itunes.apple.com/app/id1410565176
            """
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.modalPresentationStyle = .popover
        activityController.popoverPresentationController?.barButtonItem = menuButton
        activityController.completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                if let presenter = alert.popoverPresentationController {
                    presenter.barButtonItem = self.menuButton
                }
                self.present(alert, animated: true)

                return
            }
        }
        if let presenter = activityController.popoverPresentationController {
            presenter.barButtonItem = menuButton
        }

        present(activityController, animated: true)

    }


    @IBAction func showColorPicker() {
        let selectedColor: UIColor = uiColorFrom(hex: getSafeHexFromUD()) ?? getFallbackColor()
        colorPicker.selectedColor = selectedColor
        present(colorPicker, animated: true)
    }


    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let hexString = hexStringFromColor(color: colorPicker.selectedColor)
        updateColor(hexStringParam: hexString)
    }


    // MARK: Random

    @IBAction func randomPressed(_ sender: Any) {

        let activity = NSUserActivity(activityType: Const.AppInfo.bundleAndRandom)
        activity.title = "Create Random Color"
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(Const.AppInfo.bundleAndRandom)
        activity.suggestedInvocationPhrase = "ColorFull Random Color"
        view.userActivity = activity
        activity.becomeCurrent()

        makeRandomColor()

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

        var emailTitle = Const.AppInfo.appName
        if let version = Bundle.main.infoDictionary![Const.AppInfo.bundleShort] {
            emailTitle += " \(version)"
        }

        let messageBody = "Hi. I have a question..."
        let toRecipents = [Const.AppInfo.email]
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
                    presenter.barButtonItem = self.menuButton
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

        guard let writeReviewURL = URL(string: Const.AppInfo.reviewLink)
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
