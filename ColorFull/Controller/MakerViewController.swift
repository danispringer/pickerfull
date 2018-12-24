//
//  MakerViewController.swift
//  ColorFull
//
//  Created by Daniel Springer on 06/03/2018.
//  Copyright © 2018 Daniel Springer. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI
import Intents


class MakerViewController: UIViewController,
                           UIPickerViewDelegate,
                           UIPickerViewDataSource,
                           UIImagePickerControllerDelegate,
                           UINavigationControllerDelegate,
                           SKStoreProductViewControllerDelegate {


    // MARK: Outlets

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!

    @IBOutlet weak var hexPicker: UIPickerView!
    @IBOutlet weak var rgbPicker: UIPickerView!
    @IBOutlet weak var pickersSwitch: UISwitch!
    @IBOutlet weak var hexSwitchLabel: UILabel!
    @IBOutlet weak var rgbSwitchLabel: UILabel!

    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var shareToolbar: UIToolbar!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!

    @IBOutlet weak var randomToolbar: UIToolbar!
    @IBOutlet weak var randomBarButtonItem: UIBarButtonItem!


    // MARK: properties

    struct RGBResult {
        let isValid: Bool
        let invalidRgbValue: String
        let validRgbValue: [Int]
    }


    enum Controls {
        case slider
        case hexPicker
        case rgbPicker
        case pasteHexOrRandomHex
        case pasteRGB
    }


    var currentUIColor: UIColor!
    var currentHexColor: String!

    var hexArray: [String] = []
    var rgbArray: [String] = []


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        for number in 0...Int(Constants.Values.rgbMax) {
            hexArray.append(String(format: Constants.Values.numToHexFormatter, number))
        }

        for number in 0...Int(Constants.Values.rgbMax) {
            rgbArray.append(String(number))
        }

        for picker in [hexPicker, rgbPicker] {
            picker?.delegate = self
            picker?.layer.cornerRadius = 10
            picker?.layer.masksToBounds = true
        }

        messageLabel.isHidden = true

        redSlider.thumbTintColor = .red
        greenSlider.thumbTintColor = .green
        blueSlider.thumbTintColor = .blue

        redSlider.setThumbImage(UIImage(named: Constants.Image.red), for: .normal)
        redSlider.setThumbImage(UIImage(named: Constants.Image.red), for: .highlighted)
        greenSlider.setThumbImage(UIImage(named: Constants.Image.green), for: .normal)
        greenSlider.setThumbImage(UIImage(named: Constants.Image.green), for: .highlighted)
        blueSlider.setThumbImage(UIImage(named: Constants.Image.blue), for: .normal)
        blueSlider.setThumbImage(UIImage(named: Constants.Image.blue), for: .highlighted)

        redSlider.minimumTrackTintColor = UIColor.red
        greenSlider.minimumTrackTintColor = UIColor.green
        blueSlider.minimumTrackTintColor = UIColor.blue

        if UserDefaults.standard.string(forKey: Constants.UserDef.hexPickerSelected) == nil {
            UserDefaults.standard.register(defaults: [Constants.UserDef.hexPickerSelected: true])
        }

        _ = UserDefaults.standard.value(
            forKey: Constants.UserDef.hexPickerSelected) as? Bool ?? true ?
                (hexPicker.isHidden = false, rgbPicker.isHidden = true) :
            (hexPicker.isHidden = true, rgbPicker.isHidden = false)

        pickersSwitch.isOn = !(UserDefaults.standard.value(
            forKey: Constants.UserDef.hexPickerSelected) as? Bool ?? false)

        for toolbar in [shareToolbar, randomToolbar] {
            toolbar?.setShadowImage(UIImage.from(color: UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 0.5)),
                                    forToolbarPosition: .any)
            toolbar?.setBackgroundImage(UIImage.from(color: UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 0.5)),
                                        forToolbarPosition: .any, barMetrics: .default)
            toolbar?.layer.cornerRadius = 10
            toolbar?.layer.masksToBounds = true
        }

        for label in [messageLabel, hexSwitchLabel, rgbSwitchLabel] {
            label?.layer.cornerRadius = 10
            label?.layer.masksToBounds = true
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let hexString = UserDefaults.standard.string(forKey: Constants.UserDef.colorKey)

        self.redSlider.setValue(Float(Constants.Values.hexToNumFormatter +
            hexString![0...1])! /
            Float(Constants.Values.rgbMax), animated: false)
        self.greenSlider.setValue(Float(Constants.Values.hexToNumFormatter +
            hexString![2...3])! / Float(Constants.Values.rgbMax), animated: false)
        self.blueSlider.setValue(Float(Constants.Values.hexToNumFormatter +
            hexString![4...5])! / Float(Constants.Values.rgbMax), animated: false)

        let redHex = hexString![0...1]
        let greenHex = hexString![2...3]
        let blueHex = hexString![4...5]

        let redIndexHex = self.hexArray.index(of: String(redHex))
        let greenIndexHex = self.hexArray.index(of: String(greenHex))
        let blueIndexHex = self.hexArray.index(of: String(blueHex))

        self.hexPicker.selectRow(redIndexHex!, inComponent: 0, animated: false)
        self.hexPicker.selectRow(greenIndexHex!, inComponent: 1, animated: false)
        self.hexPicker.selectRow(blueIndexHex!, inComponent: 2, animated: false)

        let redIndexRGB = Int(hexString![0...1], radix: 16)
        let greenIndexRGB = Int(hexString![2...3], radix: 16)
        let blueIndexRGB = Int(hexString![4...5], radix: 16)

        self.rgbPicker.selectRow(redIndexRGB!, inComponent: 0, animated: false)
        self.rgbPicker.selectRow(greenIndexRGB!, inComponent: 1, animated: false)
        self.rgbPicker.selectRow(blueIndexRGB!, inComponent: 2, animated: false)

        self.view.backgroundColor = UIColor(red: CGFloat(self.redSlider.value),
                                            green: CGFloat(self.greenSlider.value),
                                            blue: CGFloat(self.blueSlider.value),
                                            alpha: 1)

        if UserDefaults.standard.bool(forKey: Constants.UserDef.isFirstLaunch) {
            self.presentWelcomeAlert()
        }

    }


    // MARK: Helpers

    // MARK: Show Apps

    func showApps() {

        let controller = SKStoreProductViewController()
        controller.delegate = self
        controller.loadProduct(
            withParameters: [SKStoreProductParameterITunesItemIdentifier: Constants.AppInfo.devID],
            completionBlock: nil)

        present(controller, animated: true)
    }


    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true, completion: nil)
    }


    func presentWelcomeAlert() {
        let welcomeAlert = UIAlertController(title: "❤️ Welcome",
                                             message: """
                                             ColorFull lets you create, edit and share \
                                             millions of colors with maximum precision.\nFor the \
                                             best experience and highest accuracy:\n\n🔆 Raise \
                                             your screen's brightness\n\n🌚 Turn off Night Shift \
                                             \n📜 Turn off True Tone
                                             """,
                                             preferredStyle: .actionSheet)

        let closeAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            UserDefaults.standard.set(false, forKey: Constants.UserDef.isFirstLaunch)
        }
        welcomeAlert.addAction(closeAction)

        if let presenter = welcomeAlert.popoverPresentationController {
            presenter.sourceView = self.shareToolbar
            presenter.sourceRect = self.shareToolbar.bounds
        }
        self.present(welcomeAlert, animated: true)
    }


    // MARK: Update Color

    func updateColor(control: Controls,
                     hexStringParam: String? = nil,
                     rgbArray: [Int] = [],
                     completionHandler: @escaping (Bool) -> Void = {_ in return }) {

        if control == .slider {

            let red: CGFloat = CGFloat(self.redSlider.value)
            let green: CGFloat = CGFloat(self.greenSlider.value)
            let blue: CGFloat = CGFloat(self.blueSlider.value)

            view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)

            let rBase255 = Int(red * CGFloat(Constants.Values.rgbMax))
            let gBase255 = Int(green * CGFloat(Constants.Values.rgbMax))
            let bBase255 = Int(blue * CGFloat(Constants.Values.rgbMax))

            let redHex = String(format: Constants.Values.numToHexFormatter, rBase255)
            let greenHex = String(format: Constants.Values.numToHexFormatter, gBase255)
            let blueHex = String(format: Constants.Values.numToHexFormatter, bBase255)

            let redIndex = hexArray.index(of: redHex)
            let greenIndex = hexArray.index(of: greenHex)
            let blueIndex = hexArray.index(of: blueHex)

            hexPicker.selectRow(redIndex!, inComponent: 0, animated: true)
            hexPicker.selectRow(greenIndex!, inComponent: 1, animated: true)
            hexPicker.selectRow(blueIndex!, inComponent: 2, animated: true)

            self.rgbPicker.selectRow(rBase255, inComponent: 0, animated: true)
            self.rgbPicker.selectRow(gBase255, inComponent: 1, animated: true)
            self.rgbPicker.selectRow(bBase255, inComponent: 2, animated: true)

            let hexCode = redHex + greenHex + blueHex
            UserDefaults.standard.set(hexCode, forKey: Constants.UserDef.colorKey)

        } else if control == .hexPicker {
            let redValue: Float = Float(hexPicker.selectedRow(inComponent: 0))
            let greenValue: Float = Float(hexPicker.selectedRow(inComponent: 1))
            let blueValue: Float = Float(hexPicker.selectedRow(inComponent: 2))

            UIView.animate(withDuration: 0.5, animations: {
                self.redSlider.setValue(redValue / Float(Constants.Values.rgbMax), animated: true)
                self.greenSlider.setValue(greenValue / Float(Constants.Values.rgbMax), animated: true)
                self.blueSlider.setValue(blueValue / Float(Constants.Values.rgbMax), animated: true)
                self.view.backgroundColor = UIColor(red: CGFloat(self.redSlider.value),
                                                    green: CGFloat(self.greenSlider.value),
                                                    blue: CGFloat(self.blueSlider.value),
                                                    alpha: 1)
            })

            let redHex = hexArray[hexPicker.selectedRow(inComponent: 0)]
            let greenHex = hexArray[hexPicker.selectedRow(inComponent: 1)]
            let blueHex = hexArray[hexPicker.selectedRow(inComponent: 2)]

            self.rgbPicker.selectRow(Int(redValue), inComponent: 0, animated: true)
            self.rgbPicker.selectRow(Int(greenValue), inComponent: 1, animated: true)
            self.rgbPicker.selectRow(Int(blueValue), inComponent: 2, animated: true)

            let hexCode = redHex + greenHex + blueHex
            UserDefaults.standard.set(hexCode, forKey: Constants.UserDef.colorKey)

        } else if control == .rgbPicker {
            let redValue: Double = Double(rgbPicker.selectedRow(inComponent: 0))
            let greenValue: Double = Double(rgbPicker.selectedRow(inComponent: 1))
            let blueValue: Double = Double(rgbPicker.selectedRow(inComponent: 2))

            self.hexPicker.selectRow(Int(redValue), inComponent: 0, animated: true)
            self.hexPicker.selectRow(Int(greenValue), inComponent: 1, animated: true)
            self.hexPicker.selectRow(Int(blueValue), inComponent: 2, animated: true)

            let redHex = String(format: Constants.Values.numToHexFormatter, redValue)
            let greenHex = String(format: Constants.Values.numToHexFormatter, greenValue)
            let blueHex = String(format: Constants.Values.numToHexFormatter, blueValue)

            let hexCode = redHex + greenHex + blueHex

            UIView.animate(withDuration: 0.5, animations: {
                self.redSlider.setValue(Float(redValue / Constants.Values.rgbMax), animated: true)
                self.greenSlider.setValue(Float(greenValue / Constants.Values.rgbMax), animated: true)
                self.blueSlider.setValue(Float(blueValue / Constants.Values.rgbMax), animated: true)
                self.view.backgroundColor = UIColor(red: CGFloat(self.redSlider.value),
                                                    green: CGFloat(self.greenSlider.value),
                                                    blue: CGFloat(self.blueSlider.value),
                                                    alpha: 1)
            }, completion: { _ in
                print(hexCode)
                UserDefaults.standard.set(hexCode, forKey: Constants.UserDef.colorKey)
            })

        } else if control == .pasteHexOrRandomHex {

            let redString = hexStringParam![0...1]
            let greenString = hexStringParam![2...3]
            let blueString = hexStringParam![4...5]

            let redIndex = hexArray.index(of: redString)
            let greenIndex = hexArray.index(of: greenString)
            let blueIndex = hexArray.index(of: blueString)

            hexPicker.selectRow(redIndex!, inComponent: 0, animated: true)
            hexPicker.selectRow(greenIndex!, inComponent: 1, animated: true)
            hexPicker.selectRow(blueIndex!, inComponent: 2, animated: true)

            rgbPicker.selectRow(Int(redString, radix: 16)!, inComponent: 0, animated: true)
            rgbPicker.selectRow(Int(greenString, radix: 16)!, inComponent: 1, animated: true)
            rgbPicker.selectRow(Int(blueString, radix: 16)!, inComponent: 2, animated: true)

            let redValue: Double = Double(hexPicker.selectedRow(inComponent: 0))
            let greenValue: Double = Double(hexPicker.selectedRow(inComponent: 1))
            let blueValue: Double = Double(hexPicker.selectedRow(inComponent: 2))

            UIView.animate(withDuration: 0.5, animations: {
                self.redSlider.setValue(Float(redValue / Constants.Values.rgbMax), animated: true)
                self.greenSlider.setValue(Float(greenValue / Constants.Values.rgbMax), animated: true)
                self.blueSlider.setValue(Float(blueValue / Constants.Values.rgbMax), animated: true)
                self.view.backgroundColor = UIColor(red: CGFloat(self.redSlider.value),
                                                    green: CGFloat(self.greenSlider.value),
                                                    blue: CGFloat(self.blueSlider.value),
                                                    alpha: 1)
            }, completion: { _ in

                UserDefaults.standard.set(hexStringParam, forKey: Constants.UserDef.colorKey)
                completionHandler(true)
            })

        } else if control == .pasteRGB {

            let redValue = rgbArray[0]
            let greenValue = rgbArray[1]
            let blueValue = rgbArray[2]

            let redHex = String(format: Constants.Values.numToHexFormatter, redValue)
            let greenHex = String(format: Constants.Values.numToHexFormatter, greenValue)
            let blueHex = String(format: Constants.Values.numToHexFormatter, blueValue)

            let hexString = redHex + greenHex + blueHex

            let redIndex = hexArray.index(of: redHex)
            let greenIndex = hexArray.index(of: greenHex)
            let blueIndex = hexArray.index(of: blueHex)

            hexPicker.selectRow(redIndex!, inComponent: 0, animated: true)
            hexPicker.selectRow(greenIndex!, inComponent: 1, animated: true)
            hexPicker.selectRow(blueIndex!, inComponent: 2, animated: true)

            rgbPicker.selectRow(redValue, inComponent: 0, animated: true)
            rgbPicker.selectRow(greenValue, inComponent: 1, animated: true)
            rgbPicker.selectRow(blueValue, inComponent: 2, animated: true)

            UIView.animate(withDuration: 0.5, animations: {
                self.redSlider.setValue(Float(Double(redValue) / Constants.Values.rgbMax), animated: true)
                self.greenSlider.setValue(Float(Double(greenValue) / Constants.Values.rgbMax), animated: true)
                self.blueSlider.setValue(Float(Double(blueValue) / Constants.Values.rgbMax), animated: true)
                self.view.backgroundColor = UIColor(red: CGFloat(self.redSlider.value),
                                                    green: CGFloat(self.greenSlider.value),
                                                    blue: CGFloat(self.blueSlider.value),
                                                    alpha: 1)
            }, completion: { _ in
                UserDefaults.standard.set(hexString, forKey: Constants.UserDef.colorKey)
                completionHandler(true)
            })

        } else {
            fatalError()
        }

    }


    // MARK: Sliders

    @IBAction func sliderChanged(_ sender: AnyObject) {
        updateColor(control: Controls.slider)
    }


    // MARK: Picker Switch

    @IBAction func pickerSwitchToggled(_ sender: Any) {
        UserDefaults.standard.set(!pickersSwitch.isOn, forKey: Constants.UserDef.hexPickerSelected)
        hexPicker.isHidden = pickersSwitch.isOn
        rgbPicker.isHidden = !pickersSwitch.isOn
    }


    // MARK: Pickers

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 || pickerView.tag == 1 {
            return 3
        } else {
            fatalError()
        }
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return hexArray.count
        } else if pickerView.tag == 1 {
            return rgbArray.count
        } else {
            fatalError()
        }
    }


    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int,
                    forComponent component: Int) -> NSAttributedString? {

        var string = ""

        if pickerView.tag == 0 {
            string = hexArray[row]
            return NSAttributedString(string: string,
                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        } else if pickerView.tag == 1 {
            string = rgbArray[row]
        } else {
            fatalError()
        }

        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            updateColor(control: .hexPicker)
        } else if pickerView.tag == 1 {
            updateColor(control: .rgbPicker)
        } else {
            fatalError()
        }

    }


    // MARK: Share Toolbar Options

    @IBAction func showMainMenu() {

        let mainMenuAlert = UIAlertController(title: "Main Menu", message: nil, preferredStyle: .actionSheet)

        mainMenuAlert.modalPresentationStyle = .popover

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: {
                SKStoreReviewController.requestReview()
            })
        }

        let downloadImageAction = UIAlertAction(title: "Download as image", style: .default, handler: { _ in
            self.downloadAsImage()
        })

        let copyMainAction = UIAlertAction(title: "Copy", style: .default) { _ in
            self.showCopyMainMenu()
        }

        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.showShareMainMenu()
        }

        let pasteTextAction = UIAlertAction(title: "Paste text", style: .default) { _ in
            self.showPasteMainMenu()
        }

        let infoAction = UIAlertAction(title: "Contact and info", style: .default) { _ in
            self.showInfoMainMenu()
        }

        for action in [downloadImageAction, copyMainAction, shareAction, pasteTextAction, infoAction, cancelAction] {
            mainMenuAlert.addAction(action)
        }

        if let presenter = mainMenuAlert.popoverPresentationController {
            presenter.sourceView = shareToolbar
            presenter.sourceRect = shareToolbar.bounds
        }

        present(mainMenuAlert, animated: true)
    }


    func showCopyMainMenu() {
        let copyMainMenuAlert = UIAlertController(title: "Copy Menu", message: nil, preferredStyle: .actionSheet)

        copyMainMenuAlert.modalPresentationStyle = .popover

        let backAction = UIAlertAction(title: "Back to Main Menu", style: .default) { _ in
            self.showMainMenu()
        }

        let copyTextMainAction = UIAlertAction(title: "Copy as text", style: .default, handler: { _ in
            self.showCopyTextMenu()
        })

        let copyImageAction = UIAlertAction(title: "Copy as image", style: .default) { _ in
            self.copyAsImage()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: {
                SKStoreReviewController.requestReview()
            })
        }

        for action in [backAction, copyImageAction, copyTextMainAction, cancelAction] {
            copyMainMenuAlert.addAction(action)
        }

        if let presenter = copyMainMenuAlert.popoverPresentationController {
            presenter.sourceView = shareToolbar
            presenter.sourceRect = shareToolbar.bounds
        }

        present(copyMainMenuAlert, animated: true)
    }


    func showCopyTextMenu() {
        let copyTextMenuAlert = UIAlertController(title: "Copy as Text Menu",
                                                  message: nil, preferredStyle: .actionSheet)

        copyTextMenuAlert.modalPresentationStyle = .popover

        let copyTextHexAction = UIAlertAction(title: "Copy as HEX text", style: .default) { _ in
            self.copyAsText(format: .hex)
        }

        let copyTextRGBAction = UIAlertAction(title: "Copy as RGB text", style: .default) { _ in
            self.copyAsText(format: .rgb)
        }

        let backAction = UIAlertAction(title: "Back to Copy Menu", style: .default) { _ in
            self.showCopyMainMenu()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: {
                SKStoreReviewController.requestReview()
            })
        }

        for action in [backAction, copyTextHexAction, copyTextRGBAction, cancelAction] {
            copyTextMenuAlert.addAction(action)
        }

        if let presenter = copyTextMenuAlert.popoverPresentationController {
            presenter.sourceView = shareToolbar
            presenter.sourceRect = shareToolbar.bounds
        }

        present(copyTextMenuAlert, animated: true)
    }


    func showShareMainMenu() {
        let shareMainMenuAlert = UIAlertController(title: "Share Menu", message: nil, preferredStyle: .actionSheet)
        shareMainMenuAlert.modalPresentationStyle = .popover

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: {
                SKStoreReviewController.requestReview()
            })
        }

        let backAction = UIAlertAction(title: "Back to Main Menu", style: .default) { _ in
            self.showMainMenu()
        }

        let shareTextMainAction = UIAlertAction(title: "Share as text", style: .default) { _ in
            self.showShareTextMenu()
        }

        let shareImageAction = UIAlertAction(title: "Share as image", style: .default) { _ in
            self.shareAsImage()
        }

        for action in [backAction, shareImageAction, shareTextMainAction, cancelAction] {
            shareMainMenuAlert.addAction(action)
        }

        if let presenter = shareMainMenuAlert.popoverPresentationController {
            presenter.sourceView = self.shareToolbar
            presenter.sourceRect = self.shareToolbar.bounds
        }
        self.present(shareMainMenuAlert, animated: true)
    }


    func showPasteMainMenu() {
        let pasteMainMenuAlert = UIAlertController(title: "Paste Menu", message: nil, preferredStyle: .actionSheet)
        pasteMainMenuAlert.modalPresentationStyle = .popover

        let pasteTextHexAction = UIAlertAction(title: "Paste HEX text", style: .default) { _ in
            self.pasteHexText()
        }

        let pasteTextRGBAction = UIAlertAction(title: "Paste RGB text", style: .default) { _ in
            self.pasteRGBText()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: {
                SKStoreReviewController.requestReview()
            })
        }

        let backAction = UIAlertAction(title: "Back to Main Menu", style: .default) { _ in
            self.showMainMenu()
        }

        for action in [backAction, pasteTextHexAction, pasteTextRGBAction, cancelAction] {
            pasteMainMenuAlert.addAction(action)
        }

        if let presenter = pasteMainMenuAlert.popoverPresentationController {
            presenter.sourceView = shareToolbar
            presenter.sourceRect = shareToolbar.bounds
        }

        present(pasteMainMenuAlert, animated: true)
    }


    func showShareTextMenu() {
        let shareTextMenuAlert = UIAlertController(
            title: "Share as Text Menu",
            message: nil,
            preferredStyle: .actionSheet)

        shareTextMenuAlert.modalPresentationStyle = .popover

        let shareTextHexAction = UIAlertAction(title: "Share as HEX text", style: .default) { _ in
            self.shareAsText(format: .hex)
        }

        let shareTextRGBAction = UIAlertAction(title: "Share as RGB text", style: .default) { _ in
            self.shareAsText(format: .rgb)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: {
                SKStoreReviewController.requestReview()
            })
        }

        let backAction = UIAlertAction(title: "Back to Share Menu", style: .default) { _ in
            self.showShareMainMenu()
        }

        for action in [backAction, shareTextHexAction, shareTextRGBAction, cancelAction] {
            shareTextMenuAlert.addAction(action)
        }

        if let presenter = shareTextMenuAlert.popoverPresentationController {
            presenter.sourceView = self.shareToolbar
            presenter.sourceRect = self.shareToolbar.bounds
        }
        self.present(shareTextMenuAlert, animated: true)
    }


    func showInfoMainMenu() {
        let version: String? = Bundle.main.infoDictionary![Constants.AppInfo.bundleShort] as? String
        let infoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let version = version {
            infoAlert.message = "Version \(version)"
            infoAlert.title = Constants.AppInfo.appName
        }
        infoAlert.modalPresentationStyle = .popover

        let mailAction = UIAlertAction(title: "Send feedback or question", style: .default) { _ in
            self.launchEmail()
        }

        let reviewAction = UIAlertAction(title: "Leave a review", style: .default) { _ in
            self.requestReviewManually()
        }

        let shareAppAction = UIAlertAction(title: "Share App with friends", style: .default) { _ in
            self.shareApp()
        }

        let backAction = UIAlertAction(title: "Back to Main Menu", style: .default) { _ in
            self.showMainMenu()
        }

        let showAppsAction = UIAlertAction(title: Constants.AppInfo.showAppsButtonTitle, style: .default) { _ in
            self.showApps()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: {
                SKStoreReviewController.requestReview()
            })
        }

        for action in [backAction, mailAction, reviewAction, shareAppAction,
                       showAppsAction, cancelAction] {
            infoAlert.addAction(action)
        }

        if let presenter = infoAlert.popoverPresentationController {
            presenter.sourceView = shareToolbar
            presenter.sourceRect = shareToolbar.bounds
        }

        present(infoAlert, animated: true)
    }


    // MARK: Random Toolbar

    @IBAction func randomPressed(_ sender: Any) {
        let activity = NSUserActivity(activityType: Constants.AppInfo.bundleAndRandom)
        activity.title = "Create random color"
        activity.isEligibleForSearch = true

        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(Constants.AppInfo.bundleAndRandom)
            activity.suggestedInvocationPhrase = "Show me a Random Color"
        } else {
            print("not ios 12")
        }
        view.userActivity = activity
        activity.becomeCurrent()

        makeRandomColor()
    }


    public func makeRandomColor() {
        toggleUI(enable: false)
        var randomHex = ""
        let randomRed = hexArray.randomElement()!
        let randomGreen = hexArray.randomElement()!
        let randomBlue = hexArray.randomElement()!

        randomHex = randomRed + randomGreen + randomBlue

        updateColor(control: .pasteHexOrRandomHex, hexStringParam: randomHex) { completed in
            if completed {
                self.toggleUI(enable: true)
            }
        }
    }


    func downloadAsImage() {

        let image = generateHexImage()
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
            present(alert, animated: true)
            return
        }
        let alert = createAlert(alertReasonParam: AlertReason.imageSaved)
        let goToLibraryButton = UIAlertAction(title: "Open Gallery", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: Constants.AppInfo.galleryLink)!)
        })
        alert.addAction(goToLibraryButton)
        present(alert, animated: true)
    }


    func copyAsText(format: Format) {

        let pasteboard = UIPasteboard.general

        switch format {
        case .hex:
            pasteboard.string = UserDefaults.standard.string(forKey: Constants.UserDef.colorKey)
        case .rgb:

            let hexString = UserDefaults.standard.string(forKey: Constants.UserDef.colorKey)

            let redValue = Int(hexString![0...1], radix: 16)!
            let greenValue = Int(hexString![2...3], radix: 16)!
            let blueValue = Int(hexString![4...5], radix: 16)!

            pasteboard.string = "\(redValue),\(greenValue),\(blueValue)"

        }

        let alert = createAlert(alertReasonParam: AlertReason.textCopied, format: format)
        present(alert, animated: true)
    }


    func copyAsImage() {

        let image = generateHexImage()
        let pasteboard = UIPasteboard.general
        pasteboard.image = image

        let alert = createAlert(alertReasonParam: AlertReason.imageCopied)
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
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                self.present(alert, animated: true)
                return
            }
        }
        present(activityController, animated: true)

    }


    func shareAsImage() {

        let image = generateHexImage()

        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                self.present(alert, animated: true)
                return
            }
        }
        present(activityController, animated: true)
    }


    func generateHexImage() -> UIImage {

        let hexPickerWasHidden = elementsShould(hide: true, hexPickerWasHidden: hexPicker.isHidden)

        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16)]

        let jumboAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 50)]

        let attributedMessagePreHex = NSAttributedString(
            string: "\nThe HEX value for your color is:\n",
            attributes: regularAttributes)

        let hexString = UserDefaults.standard.string(forKey: Constants.UserDef.colorKey) ?? "<error>"

        let attributedMessageJumboHex = NSAttributedString(string: hexString, attributes: jumboAttributes)

        let attributedMessagePreRGB = NSAttributedString(
            string: "\n\nThe RGB value for your color is:\n",
            attributes: regularAttributes)

        let redValue = Int(hexString[0...1], radix: 16)!
        let greenValue = Int(hexString[2...3], radix: 16)!
        let blueValue = Int(hexString[4...5], radix: 16)!

        let rgbString = "\(redValue),\(greenValue),\(blueValue)"

        let attributedMessageJumboRGB = NSAttributedString(string: rgbString, attributes: jumboAttributes)

        let attributedMessagePost = NSAttributedString(
            string: "\n\nCreated using:\nColorFull by Daniel Springer\nAvailable exclusively on the iOS App Store\n",
            attributes: regularAttributes)

        let myAttributedText = NSMutableAttributedString()

        myAttributedText.append(attributedMessagePreHex)
        myAttributedText.append(attributedMessageJumboHex)
        myAttributedText.append(attributedMessagePreRGB)
        myAttributedText.append(attributedMessageJumboRGB)
        myAttributedText.append(attributedMessagePost)

        messageLabel.attributedText = myAttributedText

        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0.0)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let hexImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        _ = elementsShould(hide: false, hexPickerWasHidden: hexPickerWasHidden)

        return hexImage
    }


    func elementsShould(hide: Bool, hexPickerWasHidden: Bool) -> Bool {
        for slider in [redSlider, greenSlider, blueSlider] {
            slider?.isHidden = hide
        }
        for toolbar in [shareToolbar, randomToolbar] {
            toolbar?.isHidden = hide
        }
        for label in [hexSwitchLabel, rgbSwitchLabel] {
            label?.isHidden = hide
        }
        pickersSwitch.isHidden = hide
        messageLabel.isHidden = !hide

        if !hide {
            _ = hexPickerWasHidden ? (rgbPicker.isHidden = false) : (hexPicker.isHidden = false)
        } else {
            for picker in [hexPicker, rgbPicker] {
                picker?.isHidden = hide
            }
        }

        return hexPickerWasHidden
    }


    func pasteHexText() {

        guard let pastedString = UIPasteboard.general.string else {
            let alert = createAlert(alertReasonParam: AlertReason.emptyPasteHex)
            present(alert, animated: true)
            return
        }

        let results = isValidHex(hex: pastedString)

        guard results.0 else {
            let alert = createAlert(alertReasonParam: AlertReason.invalidHex, invalidCode: results.1)
            present(alert, animated: true)
            return
        }

        updateColor(control: Controls.pasteHexOrRandomHex, hexStringParam: results.1)
        let alert = createAlert(alertReasonParam: AlertReason.hexPasted)
        present(alert, animated: true)

    }


    func pasteRGBText() {

        guard let pastedString = UIPasteboard.general.string else {
            let alert = createAlert(alertReasonParam: AlertReason.emptyPasteRGB)
            present(alert, animated: true)
            return
        }
        let results = isValidRGB(rgb: pastedString)

        guard results.isValid else {
            let alert = createAlert(alertReasonParam: AlertReason.invalidRGB, invalidCode: results.invalidRgbValue)
            present(alert, animated: true)
            return
        }

        updateColor(control: Controls.pasteRGB, rgbArray: results.validRgbValue)
        let alert = createAlert(alertReasonParam: AlertReason.RGBPasted)
        present(alert, animated: true)
    }


    func isValidHex(hex: String) -> (Bool, String) {

        print("hex: \(hex)")
        let uppercasedDirtyHex = hex.uppercased()
        print("uppercasedDirtyHex: \(uppercasedDirtyHex)")

        let cleanedHex = uppercasedDirtyHex.filter {
            "ABCDEF0123456789".contains($0)
        }
        print(cleanedHex)
        guard !(cleanedHex.count < 6) else {
            return (false, hex)
        }

        let firstSixChars = cleanedHex[0...5]
        print(firstSixChars)

        return (true, firstSixChars)
    }


    // n,n,n
    // then, if practical, more formats: spaces, letters, percentages, dots
    // if more are added, update filter
    // return values that are more similar to input
    func isValidRGB(rgb: String) -> RGBResult {

        let cleanedRGB = rgb.filter {
            "0123456789,".contains($0)
        }

        let stringsArray = cleanedRGB.split(separator: ",")
        let intsArray: [Int] = stringsArray.map { Int($0)!}

        guard Array(intsArray).count >= 3 else {
            return RGBResult(isValid: false, invalidRgbValue: rgb, validRgbValue: Array(intsArray))
        }

        let firstThreeValues = Array(intsArray[0...2])
        print(firstThreeValues)

        guard firstThreeValues.allSatisfy({ (0...Int(Constants.Values.rgbMax)).contains($0) }) else {
            return RGBResult(isValid: false, invalidRgbValue: rgb, validRgbValue: firstThreeValues)
        }

        return RGBResult(isValid: true, invalidRgbValue: "", validRgbValue: firstThreeValues)
    }


    func shareApp() {

        let message = """
            Look at this app: ColorFull lets you generate a color from millions of choices \
            using sliders or HEX code, and save or share your created color! \
            https://itunes.apple.com/app/id1410565176 - it's really cool!
            """
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.modalPresentationStyle = .popover
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                self.present(alert, animated: true)
                return
            }
        }
        if let presenter = activityController.popoverPresentationController {
            presenter.sourceView = shareToolbar
            presenter.sourceRect = shareToolbar.bounds
        }

        present(activityController, animated: true)
    }


    func toggleUI(enable: Bool) {

        DispatchQueue.main.async {

            for item in [self.randomBarButtonItem] {
                item?.isEnabled = enable
            }

            for toolbar in [self.randomToolbar] {
                toolbar?.isUserInteractionEnabled = enable
                toolbar?.alpha = enable ? 1.0 : 0.6
            }
        }
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

        self.present(mailComposer, animated: true, completion: nil)
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
