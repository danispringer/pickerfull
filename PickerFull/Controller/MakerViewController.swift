//
//  MakerViewController.swift
//  PickerFull
//
//  Created by Daniel Springer on 06/03/2018.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI
import Intents
import AVKit


class MakerViewController: UIViewController, UINavigationControllerDelegate, UIColorPickerViewControllerDelegate,
                           UIScrollViewDelegate, UIImagePickerControllerDelegate {


    // MARK: Outlets

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var advancedButton: UIButton!
    @IBOutlet weak var imageMenuButton: UIButton!
    @IBOutlet weak var shareOrCopyButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var downloadImageButton: UIButton!

    // MARK: properties

    var hexArrayForRandom: [String] = []
    var hexImage: UIImage!
    let colorPicker = UIColorPickerViewController()
    let imagePicker = UIImagePickerController()


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if CommandLine.arguments.contains("--pickerfullScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }

        containerScrollView.delegate = self
        containerScrollView.minimumZoomScale = 1.0
        containerScrollView.maximumZoomScale = 20.0
        containerScrollView.bouncesZoom = true
        containerScrollView.alwaysBounceHorizontal = true
        containerScrollView.alwaysBounceVertical = true
        userImageView.isUserInteractionEnabled = true
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGR.numberOfTapsRequired = 2
        containerScrollView.addGestureRecognizer(doubleTapGR)
        for number in 0...Int(Const.Values.rgbMax) {
            hexArrayForRandom.append(String(format: Const.Values.numToHexFormatter, number))
        }
        elementsShould(hide: false)
        messageLabel.layer.cornerRadius = 20
        messageLabel.layer.masksToBounds = true
        let selectedColor: UIColor = uiColorFrom(hex: getSafeHexFromUD())

        resultView.backgroundColor = selectedColor

        colorPicker.delegate = self
        colorPicker.supportsAlpha = false
        colorPicker.selectedColor = selectedColor
        colorPicker.title = "Advanced Editors"

        imagePicker.delegate = self

        aboutButton.menu = getAboutMenu()
        shareOrCopyButton.menu = getShareOrCopyMenu()
        imageMenuButton.menu = getImageMenu()

        for button: UIButton in [aboutButton, imageMenuButton, shareOrCopyButton] {
            button.showsMenuAsPrimaryAction = true
        }

        saveInitialIfEmpty()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }


    // MARK: Helpers

    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        if containerScrollView.zoomScale < containerScrollView.maximumZoomScale { // zoom in
            let point = recognizer.location(in: userImageView)

            let scrollSize = containerScrollView.frame.size
            let size = CGSize(width: scrollSize.width / containerScrollView.maximumZoomScale,
                              height: scrollSize.height / containerScrollView.maximumZoomScale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            containerScrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
        } else { // zoom out
            containerScrollView.zoom(
                to: zoomRectForScale(scale: containerScrollView.maximumZoomScale,
                                     center: recognizer.location(in: userImageView)), animated: true)
        }
    }


    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = userImageView.frame.size.height / scale
        zoomRect.size.width  = userImageView.frame.size.width  / scale
        let newCenter = containerScrollView.convert(center, from: userImageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }


    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return userImageView
    }


    func getSafeHexFromUD() -> String {
        let hexString: String = UD.string(forKey: Const.UserDef.colorKey)!
        return hexString
    }


    func showApps() {
        let myURL = URL(string: Const.AppInfo.appsLink)
        guard let safeURL = myURL else {
            let alert = createAlert(alertReasonParam: .unknown)
            if let presenter = alert.popoverPresentationController {
                presenter.sourceView = aboutButton
            }
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }

            return
        }
        UIApplication.shared.open(safeURL, options: [:], completionHandler: nil)
    }


    // MARK: Update Color

    func updateColor(hexStringParam: String) {
        let mySafeString: String = hexStringParam
        let selectedColor: UIColor = uiColorFrom(hex: mySafeString)
        self.resultView.backgroundColor = selectedColor
        colorPicker.selectedColor = selectedColor

        UD.set(mySafeString, forKey: Const.UserDef.colorKey)

    }


    // MARK: Buttons

    fileprivate func tryShowingCamera() {
        DispatchQueue.main.async {
            // already authorized
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                self.present(alert, animated: true)
            }
        }

    }


    func getImageMenu() -> UIMenu {
        let newImageFromCamera = UIAction(title: Const.AppInfo.addFromCamera, image: UIImage(systemName: "camera"),
                                          state: .off) { _ in
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                self.tryShowingCamera()
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        // access allowed
                        self.tryShowingCamera()
                    } else {
                        // access denied
                        let alert = self.createAlert(alertReasonParam: AlertReason.permissiondeniedCamera)
                        let goToSettingsButton = UIAlertAction(title: "Open Settings",
                                                               style: .default, handler: { _ in
                            if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
                                UIApplication.shared.open(url)
                            }

                        })
                        alert.addAction(goToSettingsButton)
                        if let presenter = alert.popoverPresentationController {
                            presenter.sourceView = self.imageMenuButton
                        }
                        DispatchQueue.main.async {
                            self.present(alert, animated: true)
                        }
                    }
                })
            }
        }
        let newImageFromGallery = UIAction(title: Const.AppInfo.addFromGallery,
                                           image: UIImage(systemName: "photo.fill.on.rectangle.fill"),
                                           state: .off) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = false

                DispatchQueue.main.async {
                    self.present(self.imagePicker, animated: true, completion: nil)
                }

            }
        }
        let clearImage = UIAction(title: Const.AppInfo.clearImage,
                                  image: UIImage(systemName: "trash"), attributes: .destructive, state: .off) { _ in
            self.userImageView.image = nil
            self.userImageView.accessibilityLabel = ""
        }

        let imageMenu = UIMenu(title: "", image: nil, options: .displayInline,
                               children: [newImageFromCamera, newImageFromGallery, clearImage])
        return imageMenu
    }


    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        userImageView.image = image
        self.userImageView.accessibilityLabel = "Image"
        containerScrollView.zoomScale = containerScrollView.minimumZoomScale
        imagePicker.dismiss(animated: true, completion: nil)
    }


    func getAboutMenu() -> UIMenu {

        let version: String? = Bundle.main.infoDictionary?[Const.AppInfo.bundleShort] as? String

        let shareApp = UIAction(title: Const.AppInfo.shareApp, image: UIImage(systemName: "heart"),
                                state: .off) { _ in
            self.shareApp()
        }
        let review = UIAction(title: Const.AppInfo.leaveReview,
                              image: UIImage(systemName: "hand.thumbsup"), state: .off) { _ in
            self.requestReviewManually()
        }
        let moreApps = UIAction(title: Const.AppInfo.showAppsButtonTitle, image: UIImage(systemName: "apps.iphone"),
                                state: .off) { _ in
            self.showApps()
        }


        var myTitle = Const.AppInfo.appName
        if let safeVersion = version {
            myTitle += " \(Const.AppInfo.version) \(safeVersion)"
        }

        let aboutMenu = UIMenu(title: myTitle, image: nil, options: .displayInline,
                               children: [review, shareApp, moreApps])
        return aboutMenu
    }


    @IBAction func historyButtonTapped() {
        let magicVC = UIStoryboard(name: Const.StoryboardIDIB.main, bundle: nil)
            .instantiateViewController(withIdentifier: Const.StoryboardIDIB.magicTableVC)

        self.navigationController?.pushViewController(magicVC, animated: true)

    }


    func getShareOrCopyMenu() -> UIMenu {

        let shareTextHexAction = UIAction(title: "Share as HEX",
                                          image: UIImage(systemName: "doc.text")) { _ in
            self.shareAsText(format: .hex)
        }

        let shareTextRGBAction = UIAction(title: "Share as RGB",
                                          image: UIImage(systemName: "doc.text")) { _ in
            self.shareAsText(format: .rgb)
        }

        let shareImageAction = UIAction(title: "Share as image",
                                        image: UIImage(systemName: "photo")) { _ in
            self.shareAsImage()
        }
        let copyTextHexAction = UIAction(title: "Copy as HEX",
                                         image: UIImage(systemName: "doc.on.doc")) { _ in
            self.copyAsText(format: .hex)
        }
        let copyTextRgbAction = UIAction(title: "Copy as RGB",
                                         image: UIImage(systemName: "doc.on.doc")) { _ in
            self.copyAsText(format: .rgb)
        }
        let copyImageAction = UIAction(title: "Copy as image",
                                        image: UIImage(systemName: "photo")) { _ in
            self.copyAsImage()
        }

        let shareMenu = UIMenu(options: .displayInline, children: [
            shareImageAction, shareTextRGBAction, shareTextHexAction,
            copyImageAction, copyTextRgbAction, copyTextHexAction])

        return shareMenu

    }


    @IBAction func downloadAsImage() {
        let image = generateImage()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }


    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            let alert = createAlert(alertReasonParam: AlertReason.permissionDeniedGallery)
            let goToSettingsButton = UIAlertAction(title: "Open Settings",
                                                   style: .default, handler: { _ in
                if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
                    UIApplication.shared.open(url)
                }
            })
            alert.addAction(goToSettingsButton)
            if let presenter = alert.popoverPresentationController {
                presenter.sourceView = shareOrCopyButton
            }
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            return
        }
        let alert = createAlert(alertReasonParam: AlertReason.imageSaved)
        let openLibraryButton = UIAlertAction(title: "Open Gallery",
                                              style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: Const.AppInfo.galleryLink)!)

        })
        alert.addAction(openLibraryButton)
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = shareOrCopyButton
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }

    }


    func copyAsText(format: Format) {
        var myText = ""
        switch format {
            case .hex:
                myText = getSafeHexFromUD()
            case .rgb:
                let hexString = getSafeHexFromUD()
                myText = rgbFrom(hex: hexString)
        }
        UIPasteboard.general.string = myText
    }


    func shareAsText(format: Format) {
        var myText = ""
        switch format {
            case .hex:
                myText = getSafeHexFromUD()
            case .rgb:
                let hexString = getSafeHexFromUD()
                myText = rgbFrom(hex: hexString)
        }
        let activityController = UIActivityViewController(activityItems: [myText], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = shareOrCopyButton
        activityController.completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                if let presenter = alert.popoverPresentationController {
                    presenter.sourceView = self.shareOrCopyButton
                }
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }

                return
            }
        }
        DispatchQueue.main.async {
            self.present(activityController, animated: true)
        }

    }


    func shareAsImage() {
        let image = generateImage()

        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = shareOrCopyButton
        activityController.completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                if let presenter = alert.popoverPresentationController {
                    presenter.sourceView = self.shareOrCopyButton
                }
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }


                return
            }
        }
        DispatchQueue.main.async {
            self.present(activityController, animated: true)
        }

    }


    func copyAsImage() {
        let image = generateImage()
        UIPasteboard.general.image = image
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

        let rgbString = rgbFrom(hex: hexString)
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
        qrImageView.isHidden = !hide
        for button: UIButton in [aboutButton, advancedButton, imageMenuButton, shareOrCopyButton,
                                 randomButton, historyButton, downloadImageButton] {
            button.isHidden = hide
        }
        containerScrollView.isHidden = hide
    }


    func shareApp() {

        let message = "https://apps.apple.com/app/id1410565176"

        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.modalPresentationStyle = .popover
        activityController.popoverPresentationController?.sourceView = aboutButton
        activityController.completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                if let presenter = alert.popoverPresentationController {
                    presenter.sourceView = self.aboutButton
                }
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }

                return
            }
        }
        if let presenter = activityController.popoverPresentationController {
            presenter.sourceView = aboutButton
        }

        DispatchQueue.main.async {
            self.present(activityController, animated: true)
        }

    }


    @IBAction func showColorPicker() {
        let selectedColor: UIColor = uiColorFrom(hex: getSafeHexFromUD())
        colorPicker.selectedColor = selectedColor
        DispatchQueue.main.async {
            self.present(self.colorPicker, animated: true)
        }

    }


    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let hexString = hexStringFromColor(color: colorPicker.selectedColor)
        updateColor(hexStringParam: hexString)
    }


    // MARK: Random

    @IBAction func randomTapped(_ sender: Any) {
        makeRandomColor()
    }


    public func makeRandomColor() {
        var randomHex = ""
        let randomRed = hexArrayForRandom.randomElement()!
        let randomGreen = hexArrayForRandom.randomElement()!
        let randomBlue = hexArrayForRandom.randomElement()!

        randomHex = randomRed + randomGreen + randomBlue

        updateColor(hexStringParam: randomHex)
        saveToUD(color: randomHex)
    }


    func saveToUD(color: String) {

        if UD.dictionary(forKey: Const.UserDef.magicDict) == nil {
            let emptyDict: [String: String] = [:]
            UD.register(defaults: [Const.UserDef.magicDict: emptyDict])
        }

        var savedColors = UD.dictionary(forKey: Const.UserDef.magicDict) as! [String: String]
        let now = "\(Date().timeIntervalSince1970)"
        if savedColors.count >= 10 { // need to purge oldest color

            var sortedDict = savedColors.sorted {
                Double($0.key)! > Double($1.key)!
            }
            let last = sortedDict.popLast()
            savedColors[last!.key] = nil
        }
        savedColors[now] = color
        UD.setValue(savedColors, forKey: Const.UserDef.magicDict)
    }


    func saveInitialIfEmpty() {
        if let currentDict = UD.dictionary(forKey: Const.UserDef.magicDict) as? [String: String],
           !currentDict.isEmpty {
            return
        }

        let now = "\(Date().timeIntervalSince1970)"
        let initialDict: [String: String] = [now: Const.UserDef.defaultColor]
        UD.register(defaults: [Const.UserDef.magicDict: initialDict])
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
