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
import AVKit
import UniformTypeIdentifiers


class MakerViewController: UIViewController, UINavigationControllerDelegate,
                           UIColorPickerViewControllerDelegate, UIScrollViewDelegate,
                           UIImagePickerControllerDelegate, UIDropInteractionDelegate {


    // MARK: Outlets

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var pickerMenuButton: UIButton!
    @IBOutlet weak var imageMenuButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var randomHistoryButton: UIButton!
    @IBOutlet weak var advancedHistoryButton: UIButton!
    @IBOutlet weak var shareOrSaveButton: UIButton!

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
        let doubleTapGR = UITapGestureRecognizer(target: self,
                                                 action: #selector(handleDoubleTap))
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
        colorPicker.title = "Advanced Editor"

        imagePicker.delegate = self

        aboutButton.menu = getAboutMenu()
        shareOrSaveButton.menu = getShareOrSaveMenu()
        imageMenuButton.menu = getImageMenu()

        for button: UIButton in [aboutButton, imageMenuButton, shareOrSaveButton] {
            button.showsMenuAsPrimaryAction = true
        }

        for button: UIButton in [aboutButton, pickerMenuButton, imageMenuButton,
                                 shareOrSaveButton, randomButton, randomHistoryButton,
                                 advancedHistoryButton] {
            button.clipsToBounds = true
            button.layer.cornerRadius = 8
            button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }

        let dropInteraction = UIDropInteraction(delegate: self)
        userImageView.addInteraction(dropInteraction)


    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !UD.bool(forKey: Const.UserDef.tutorialShown) {
            showTutorial()
            UD.set(true, forKey: Const.UserDef.tutorialShown)
        }
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }


    // MARK: Helpers

    func showTutorial() {
        let storyboard = UIStoryboard(name: Const.StoryboardIDIB.main, bundle: nil)
        let tutorialVC = storyboard.instantiateViewController(
            withIdentifier: Const.StoryboardIDIB.tutorialVC)
        present(tutorialVC, animated: true)
    }


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
                                     center: recognizer.location(in: userImageView)),
                animated: true)
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
            let alert = createAlert(alertReasonParam: .unknown,
                                    okMessage: Const.AppInfo.okMessage)
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
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown,
                                             okMessage: Const.AppInfo.okMessage)
                self.present(alert, animated: true)
            }
        }

    }


    func getImageMenu() -> UIMenu {
        let newImageFromCamera = UIAction(title: Const.AppInfo.addFromCamera,
                                          image: UIImage(systemName: "camera"),
                                          state: .off) { _ in
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                self.tryShowingCamera()
            } else {
                AVCaptureDevice.requestAccess(for: .video,
                                              completionHandler: { [self] (granted: Bool) in
                    if granted {
                        // access allowed
                        tryShowingCamera()
                    } else {
                        // access denied
                        let alert = createAlert(
                            alertReasonParam: AlertReason.permissiondeniedCamera,
                            okMessage: Const.AppInfo.notNowMessage)
                        let goToSettingsButton = UIAlertAction(title: "Open Settings",
                                                               style: .default, handler: { _ in
                            if let url = NSURL(string: UIApplication.openSettingsURLString)
                                as URL? {
                                UIApplication.shared.open(url)
                            }

                        })
                        alert.addAction(goToSettingsButton)
                        if let presenter = alert.popoverPresentationController {
                            presenter.sourceView = imageMenuButton
                        }
                        DispatchQueue.main.async { [self] in
                            present(alert, animated: true)
                        }
                    }
                })
            }
        }
        let newImageFromGallery = UIAction(
            title: Const.AppInfo.addFromGallery,
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
                                  image: UIImage(systemName: "trash"),
                                  attributes: .destructive, state: .off) { _ in
            self.userImageView.image = nil
            self.userImageView.accessibilityLabel = ""
        }

        let imageMenu = UIMenu(title: "", image: nil, options: .displayInline,
                               children: [newImageFromCamera, newImageFromGallery, clearImage])
        return imageMenu
    }


    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        userImageView.image = image
        self.userImageView.accessibilityLabel = "Image"
        containerScrollView.zoomScale = containerScrollView.minimumZoomScale
        imagePicker.dismiss(animated: true, completion: nil)
    }


    func getAboutMenu() -> UIMenu {

        let version: String? = Bundle.main.infoDictionary?[Const.AppInfo.appVersion] as? String

        let shareApp = UIAction(title: Const.AppInfo.shareApp,
                                image: UIImage(systemName: "heart"),
                                state: .off) { _ in
            self.shareApp()
        }
        let review = UIAction(title: Const.AppInfo.leaveReview,
                              image: UIImage(systemName: "hand.thumbsup"), state: .off) { _ in
            self.requestReviewManually()
        }
        let moreApps = UIAction(title: Const.AppInfo.showAppsButtonTitle,
                                image: UIImage(systemName: "apps.iphone"),
                                state: .off) { _ in
            self.showApps()
        }


        let tutorial = UIAction(title: Const.AppInfo.tutorial,
                                image: UIImage(systemName: "play.circle"),
                                state: .off) { _ in
            self.showTutorial()
        }

        let emailAction = UIAction(title: Const.AppInfo.contact,
                                   image: UIImage(systemName: "envelope.badge"),
                                   state: .off) { _ in
            self.sendEmailTapped()
        }


        var myTitle = Const.AppInfo.appName
        if let safeVersion = version {
            myTitle += " \(Const.AppInfo.version) \(safeVersion)"
        }

        let aboutMenu = UIMenu(title: myTitle, image: nil, options: .displayInline,
                               children: [emailAction, review, shareApp, moreApps, tutorial])
        return aboutMenu
    }


    @IBAction func historyButtonTapped() {
        let magicVC = UIStoryboard(name: Const.StoryboardIDIB.main, bundle: nil)
            .instantiateViewController(withIdentifier: Const.StoryboardIDIB.magicTableVC)

        self.navigationController?.pushViewController(magicVC, animated: true)

    }


    @IBAction func advancedHistoryTapped() {
        let advancedVC = UIStoryboard(name: Const.StoryboardIDIB.main, bundle: nil)
            .instantiateViewController(withIdentifier: Const.StoryboardIDIB.advancedTableVC)

        self.navigationController?.pushViewController(advancedVC, animated: true)
    }


    func getShareOrSaveMenu() -> UIMenu {

        let generateImageAction = UIAction(
            title: "Generate Screenshot",
            image: UIImage(systemName: "square.and.arrow.down")) { _ in
                self.generateImage()
            }

        let shareTextHexAction = UIAction(title: "Share as HEX",
                                          image: UIImage(systemName: "doc.text")) { _ in
            self.shareAsText(format: .hex)
        }

        let shareTextRGBAction = UIAction(title: "Share as RGB",
                                          image: UIImage(systemName: "doc.text")) { _ in
            self.shareAsText(format: .rgb)
        }
        let copyTextHexAction = UIAction(title: "Copy as HEX",
                                         image: UIImage(systemName: "doc.on.doc")) { _ in
            self.copyAsText(format: .hex)
        }
        let copyTextRgbAction = UIAction(title: "Copy as RGB",
                                         image: UIImage(systemName: "doc.on.doc")) { _ in
            self.copyAsText(format: .rgb)
        }

        let shareMenu = UIMenu(options: .displayInline, children: [
            generateImageAction, shareTextRGBAction, shareTextHexAction,
            copyTextRgbAction, copyTextHexAction])

        return shareMenu

    }


    func presentImagePreview() {
        let imagePreviewVC = UIStoryboard(
            name: Const.StoryboardIDIB.main, bundle: nil).instantiateViewController(
                withIdentifier: Const.StoryboardIDIB.imagePreviewVC)
        as! ImagePreviewViewController
        imagePreviewVC.actualImage = hexImage!
        present(imagePreviewVC, animated: true)
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
        let activityController = UIActivityViewController(activityItems: [myText],
                                                          applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = shareOrSaveButton
        activityController
            .completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
                guard error == nil else {
                    let alert = self.createAlert(alertReasonParam: AlertReason.unknown,
                                                 okMessage: Const.AppInfo.okMessage)
                    if let presenter = alert.popoverPresentationController {
                        presenter.sourceView = self.shareOrSaveButton
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


    func generateImage() {

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
        let attributedMessageJumboHex = NSAttributedString(string: hexString,
                                                           attributes: jumboAttributes)
        let attributedMessagePreRGB = NSAttributedString(
            string: "\n\nRGB\n",
            attributes: regularAttributes)

        let rgbString = rgbFrom(hex: hexString)
        let myUIColor = uiColorFrom(hex: hexString)

        let attributedMessageJumboRGB = NSAttributedString(string: rgbString,
                                                           attributes: jumboAttributes)

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

        presentImagePreview()
    }


    func elementsShould(hide: Bool) {
        messageLabel.isHidden = !hide
        qrImageView.isHidden = !hide
        for button: UIButton in [aboutButton, pickerMenuButton, imageMenuButton,
                                 shareOrSaveButton, randomButton, randomHistoryButton,
                                 advancedHistoryButton] {
            button.isHidden = hide
        }
        containerScrollView.isHidden = hide
    }


    func shareApp() {

        let message = "https://apps.apple.com/app/id1410565176"

        let activityController = UIActivityViewController(activityItems: [message],
                                                          applicationActivities: nil)
        activityController.modalPresentationStyle = .popover
        activityController.popoverPresentationController?.sourceView = aboutButton
        activityController
            .completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
                guard error == nil else {
                    let alert = self.createAlert(alertReasonParam: AlertReason.unknown,
                                                 okMessage: Const.AppInfo.okMessage)
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


    @IBAction func pickerMenuButtonTapped() {
        let selectedColor: UIColor = uiColorFrom(hex: getSafeHexFromUD())
        colorPicker.selectedColor = selectedColor
        DispatchQueue.main.async { [self] in
            colorPicker.popoverPresentationController?.sourceView = pickerMenuButton
            present(colorPicker, animated: true)
            if !UD.bool(forKey: Const.UserDef.xSavesShown) {
                let alert = createAlert(alertReasonParam: .xSaves, okMessage: "I understand")
                colorPicker.present(alert, animated: true)
                UD.set(true, forKey: Const.UserDef.xSavesShown)
            }
        }

    }


    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let hexString = hexStringFromColor(color: colorPicker.selectedColor)
        updateColor(hexStringParam: hexString)
        saveToFiles(color: hexString, filename: Const.UserDef.advancedHistoryFilename)
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
        saveToFiles(color: randomHex, filename: Const.UserDef.randomHistoryFilename)
    }


}


extension MakerViewController: MFMailComposeViewControllerDelegate {

    func sendEmailTapped() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }


    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the
        // --mailComposeDelegate-- property, NOT the --delegate-- property

        mailComposerVC.setToRecipients([Const.AppInfo.emailString])
        let version: String? = Bundle.main.infoDictionary![Const.AppInfo.appVersion] as? String
        var myTitle = Const.AppInfo.appName
        if let safeVersion = version {
            myTitle += " \(Const.AppInfo.version) \(safeVersion)"
        }
        mailComposerVC.setSubject(myTitle)
        mailComposerVC.setMessageBody("Hi, I have a question about your app.", isHTML: false)

        return mailComposerVC
    }


    func showSendMailErrorAlert() {
        let alert = createAlert(alertReasonParam: .emailError,
                                okMessage: Const.AppInfo.okMessage)
        present(alert, animated: true)
    }


    // MARK: MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}


extension MakerViewController {

    func dropInteraction(_ interaction: UIDropInteraction,
                         canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [UTType.image.identifier]) &&
        session.items.count == 1
    }


    func dropInteraction(_ interaction: UIDropInteraction,
                         sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: view)
        //        updateLayers(forDropLocation: dropLocation)

        let operation: UIDropOperation

        if userImageView.frame.contains(dropLocation) {
            /*
             If you add in-app drag-and-drop support for the .move operation,
             you must write code to coordinate between the drag interaction
             delegate and the drop interaction delegate.
             */
            userImageView.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.7)
            operation = session.localDragSession == nil ? .copy : .move
        } else {
            // Do not allow dropping outside of the image view.
            userImageView.backgroundColor = .clear
            operation = .cancel
        }
        return UIDropProposal(operation: operation)
    }


    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        // Consume drag items (in this example, of type UIImage).
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            let images = imageItems as! [UIImage]

            /*
             If you do not employ the loadObjects(ofClass:completion:) convenience
             method of the UIDropSession class, which automatically employs
             the main thread, explicitly dispatch UI work to the main thread.
             For example, you can use `DispatchQueue.main.async` method.
             */
            self.userImageView.image = images.first
            self.userImageView.backgroundColor = .clear
        }

        // Perform additional UI updates as needed.
        // let dropLocation = session.location(in: view)
    }

}


extension MakerViewController {

    func requestReviewManually() {
        guard let writeReviewURL = URL(string: Const.AppInfo.reviewLink)
        else {
            fatalError("Expected a valid URL")
        }

        UIApplication.shared.open(
            writeReviewURL,
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
private func convertFromUIImagePickerControllerInfoKey(
    _ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }


// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(
    _ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
