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
                           UIPickerViewDelegate,
                           UIPickerViewDataSource,
                           UINavigationControllerDelegate {


    // MARK: Outlets

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!

    @IBOutlet weak var hexPicker: UIPickerView!
    @IBOutlet weak var rgbPicker: UIPickerView!

    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var aboutBarButtonItem: UIBarButtonItem!

    @IBOutlet weak var randomBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var randomHistoryBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var mySwitchButton: UIBarButtonItem!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var separatorView: UIView!

    // MARK: properties

    enum Controls {
        case slider
        case hexPicker
        case rgbPicker
        case pasteHex
        case randomHex
        case pasteRGB
    }

    var currentUIColor: UIColor!
    var currentHexColor: String!

    var hexArray: [String] = []
    var rgbArray: [String] = []

    var hexImage: UIImage!

    var textColor = UIColor.label
    var backgroundColor = UIColor.systemBackground

    let animationDuration = 0.3


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
            picker?.layer.masksToBounds = true

        }

        messageLabel.isHidden = true
        redSlider.thumbTintColor = .red
        greenSlider.thumbTintColor = .green
        blueSlider.thumbTintColor = .blue

        redSlider.minimumTrackTintColor = UIColor.red
        greenSlider.minimumTrackTintColor = UIColor.green
        blueSlider.minimumTrackTintColor = UIColor.blue

        messageLabel.layer.cornerRadius = 20
        messageLabel.layer.masksToBounds = true

        let hexPickerIsSelected = UserDefaults.standard.bool(
            forKey: Constants.UserDef.hexPickerSelected)

        hexPicker.isHidden = !hexPickerIsSelected
        rgbPicker.isHidden = hexPickerIsSelected

        let prefixMessage = "Switch to "

        mySwitchButton.title = prefixMessage + (hexPickerIsSelected ? "RGB" : "HEX")

        let hexString = UserDefaults.standard.string(forKey: Constants.UserDef.colorKey)

        redSlider.setValue(Float(Constants.Values.hexToNumFormatter +
            hexString![0...1])! /
            Float(Constants.Values.rgbMax), animated: false)
        greenSlider.setValue(Float(Constants.Values.hexToNumFormatter +
            hexString![2...3])! / Float(Constants.Values.rgbMax), animated: false)
        blueSlider.setValue(Float(Constants.Values.hexToNumFormatter +
            hexString![4...5])! / Float(Constants.Values.rgbMax), animated: false)

        let redHex = hexString![0...1]
        let greenHex = hexString![2...3]
        let blueHex = hexString![4...5]

        let redIndexHex = hexArray.firstIndex(of: String(redHex))
        let greenIndexHex = hexArray.firstIndex(of: String(greenHex))
        let blueIndexHex = hexArray.firstIndex(of: String(blueHex))

        hexPicker.selectRow(redIndexHex!, inComponent: 0, animated: false)
        hexPicker.selectRow(greenIndexHex!, inComponent: 1, animated: false)
        hexPicker.selectRow(blueIndexHex!, inComponent: 2, animated: false)

        let redIndexRGB = Int(hexString![0...1], radix: 16)
        let greenIndexRGB = Int(hexString![2...3], radix: 16)
        let blueIndexRGB = Int(hexString![4...5], radix: 16)

        rgbPicker.selectRow(redIndexRGB!, inComponent: 0, animated: false)
        rgbPicker.selectRow(greenIndexRGB!, inComponent: 1, animated: false)
        rgbPicker.selectRow(blueIndexRGB!, inComponent: 2, animated: false)

        resultView.backgroundColor = UIColor(red: CGFloat(redSlider.value),
                                             green: CGFloat(greenSlider.value),
                                             blue: CGFloat(blueSlider.value),
                                             alpha: 1)

        // add to toggle UI func when removing
        randomHistoryBarButtonItem.isEnabled = false

    }


    // MARK: Helpers

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

    func updateColor(control: Controls,
                     hexStringParam: String? = nil,
                     rgbArray: [Int] = [],
                     completionHandler: @escaping (Bool) -> Void = {_ in return }) {

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0

            if control == .slider {

                red = CGFloat(redSlider.value)
                green = CGFloat(greenSlider.value)
                blue = CGFloat(blueSlider.value)

                resultView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)

                let rBase255 = Int(red * CGFloat(Constants.Values.rgbMax))
                let gBase255 = Int(green * CGFloat(Constants.Values.rgbMax))
                let bBase255 = Int(blue * CGFloat(Constants.Values.rgbMax))

                let redHex = String(format: Constants.Values.numToHexFormatter, rBase255)
                let greenHex = String(format: Constants.Values.numToHexFormatter, gBase255)
                let blueHex = String(format: Constants.Values.numToHexFormatter, bBase255)

                let redIndex = hexArray.firstIndex(of: redHex)
                let greenIndex = hexArray.firstIndex(of: greenHex)
                let blueIndex = hexArray.firstIndex(of: blueHex)

                hexPicker.selectRow(redIndex!, inComponent: 0, animated: true)
                hexPicker.selectRow(greenIndex!, inComponent: 1, animated: true)
                hexPicker.selectRow(blueIndex!, inComponent: 2, animated: true)

                rgbPicker.selectRow(rBase255, inComponent: 0, animated: true)
                rgbPicker.selectRow(gBase255, inComponent: 1, animated: true)
                rgbPicker.selectRow(bBase255, inComponent: 2, animated: true)

                let hexCode = redHex + greenHex + blueHex
                UserDefaults.standard.set(hexCode, forKey: Constants.UserDef.colorKey)

            } else if control == .hexPicker {
                let redValue: Float = Float(hexPicker.selectedRow(inComponent: 0))
                let greenValue: Float = Float(hexPicker.selectedRow(inComponent: 1))
                let blueValue: Float = Float(hexPicker.selectedRow(inComponent: 2))

                let redHex = hexArray[hexPicker.selectedRow(inComponent: 0)]
                let greenHex = hexArray[hexPicker.selectedRow(inComponent: 1)]
                let blueHex = hexArray[hexPicker.selectedRow(inComponent: 2)]

                rgbPicker.selectRow(Int(redValue), inComponent: 0, animated: true)
                rgbPicker.selectRow(Int(greenValue), inComponent: 1, animated: true)
                rgbPicker.selectRow(Int(blueValue), inComponent: 2, animated: true)

                let hexCode = redHex + greenHex + blueHex

                UIView.animate(withDuration: animationDuration, animations: {
                    self.redSlider.setValue(redValue / Float(Constants.Values.rgbMax), animated: true)
                    self.greenSlider.setValue(greenValue / Float(Constants.Values.rgbMax), animated: true)
                    self.blueSlider.setValue(blueValue / Float(Constants.Values.rgbMax), animated: true)
                    self.resultView.backgroundColor = UIColor(red: CGFloat(self.redSlider.value),
                                                              green: CGFloat(self.greenSlider.value),
                                                              blue: CGFloat(self.blueSlider.value),
                                                              alpha: 1)
                }, completion: { _ in
                    UserDefaults.standard.set(hexCode, forKey: Constants.UserDef.colorKey)
                    completionHandler(true)
                })


            } else if control == .rgbPicker {

                let redValue = Double(rgbPicker.selectedRow(inComponent: 0))
                let greenValue = Double(rgbPicker.selectedRow(inComponent: 1))
                let blueValue = Double(rgbPicker.selectedRow(inComponent: 2))

                hexPicker.selectRow(Int(redValue), inComponent: 0, animated: true)
                hexPicker.selectRow(Int(greenValue), inComponent: 1, animated: true)
                hexPicker.selectRow(Int(blueValue), inComponent: 2, animated: true)

                let redHex = String(format: Constants.Values.numToHexFormatter, Int(redValue))
                let greenHex = String(format: Constants.Values.numToHexFormatter, Int(greenValue))
                let blueHex = String(format: Constants.Values.numToHexFormatter, Int(blueValue))

                let hexCode = redHex + greenHex + blueHex

                UIView.animate(withDuration: animationDuration, animations: {
                    self.redSlider.setValue(Float(redValue / Constants.Values.rgbMax), animated: true)
                    self.greenSlider.setValue(Float(greenValue / Constants.Values.rgbMax), animated: true)
                    self.blueSlider.setValue(Float(blueValue / Constants.Values.rgbMax), animated: true)
                    self.resultView.backgroundColor = UIColor(red: CGFloat(self.redSlider.value),
                                                         green: CGFloat(self.greenSlider.value),
                                                         blue: CGFloat(self.blueSlider.value),
                                                              alpha: 1)

                }, completion: { _ in
                    UserDefaults.standard.set(hexCode, forKey: Constants.UserDef.colorKey)
                    completionHandler(true)
                })


            } else if control == .pasteHex {
                if hexStringParam == UserDefaults.standard.string(forKey: Constants.UserDef.colorKey) {
                    completionHandler(true)
                    let alert = createAlert(alertReasonParam: .pastedIsSame)
                    if let presenter = alert.popoverPresentationController {
                        presenter.barButtonItem = aboutBarButtonItem
                    }
                    present(alert, animated: true)
                    return
                }

                let redString = hexStringParam![0...1]
                let greenString = hexStringParam![2...3]
                let blueString = hexStringParam![4...5]

                let redIndex = hexArray.firstIndex(of: redString)
                let greenIndex = hexArray.firstIndex(of: greenString)
                let blueIndex = hexArray.firstIndex(of: blueString)

                hexPicker.selectRow(redIndex!, inComponent: 0, animated: true)
                hexPicker.selectRow(greenIndex!, inComponent: 1, animated: true)
                hexPicker.selectRow(blueIndex!, inComponent: 2, animated: true)

                rgbPicker.selectRow(Int(redString, radix: 16)!, inComponent: 0, animated: true)
                rgbPicker.selectRow(Int(greenString, radix: 16)!, inComponent: 1, animated: true)
                rgbPicker.selectRow(Int(blueString, radix: 16)!, inComponent: 2, animated: true)

                var redValue: Double = 0
                var greenValue: Double = 0
                var blueValue: Double = 0

                redValue = Double(hexPicker.selectedRow(inComponent: 0))
                greenValue = Double(hexPicker.selectedRow(inComponent: 1))
                blueValue = Double(hexPicker.selectedRow(inComponent: 2))

                UIView.animate(withDuration: animationDuration, animations: {
                    self.redSlider.setValue(Float(redValue / Constants.Values.rgbMax), animated: true)
                    self.greenSlider.setValue(Float(greenValue / Constants.Values.rgbMax), animated: true)
                    self.blueSlider.setValue(Float(blueValue / Constants.Values.rgbMax), animated: true)
                    self.resultView.backgroundColor = UIColor(red: CGFloat(self.redSlider.value),
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

                if hexString == UserDefaults.standard.string(forKey: Constants.UserDef.colorKey) {
                    completionHandler(true)
                    let alert = createAlert(alertReasonParam: .pastedIsSame)
                    if let presenter = alert.popoverPresentationController {
                        presenter.barButtonItem = aboutBarButtonItem
                    }
                    present(alert, animated: true)
                    return
                }

                let redIndex = hexArray.firstIndex(of: redHex)
                let greenIndex = hexArray.firstIndex(of: greenHex)
                let blueIndex = hexArray.firstIndex(of: blueHex)

                hexPicker.selectRow(redIndex!, inComponent: 0, animated: true)
                hexPicker.selectRow(greenIndex!, inComponent: 1, animated: true)
                hexPicker.selectRow(blueIndex!, inComponent: 2, animated: true)

                rgbPicker.selectRow(redValue, inComponent: 0, animated: true)
                rgbPicker.selectRow(greenValue, inComponent: 1, animated: true)
                rgbPicker.selectRow(blueValue, inComponent: 2, animated: true)

                UIView.animate(withDuration: animationDuration, animations: {
                    self.redSlider.setValue(Float(Double(redValue) / Constants.Values.rgbMax), animated: true)
                    self.greenSlider.setValue(Float(Double(greenValue) / Constants.Values.rgbMax), animated: true)
                    self.blueSlider.setValue(Float(Double(blueValue) / Constants.Values.rgbMax), animated: true)
                    self.resultView.backgroundColor = UIColor(red: CGFloat(self.redSlider.value),
                                                         green: CGFloat(self.greenSlider.value),
                                                         blue: CGFloat(self.blueSlider.value),
                                                              alpha: 1)
                }, completion: { _ in
                    UserDefaults.standard.set(hexString, forKey: Constants.UserDef.colorKey)
                    completionHandler(true)
                })

            } else if control == .randomHex {

                let redString = hexStringParam![0...1]
                let greenString = hexStringParam![2...3]
                let blueString = hexStringParam![4...5]

                let redIndex = hexArray.firstIndex(of: redString)
                let greenIndex = hexArray.firstIndex(of: greenString)
                let blueIndex = hexArray.firstIndex(of: blueString)

                hexPicker.selectRow(redIndex!, inComponent: 0, animated: true)
                hexPicker.selectRow(greenIndex!, inComponent: 1, animated: true)
                hexPicker.selectRow(blueIndex!, inComponent: 2, animated: true)

                rgbPicker.selectRow(Int(redString, radix: 16)!, inComponent: 0, animated: true)
                rgbPicker.selectRow(Int(greenString, radix: 16)!, inComponent: 1, animated: true)
                rgbPicker.selectRow(Int(blueString, radix: 16)!, inComponent: 2, animated: true)

                var redValue: Double = 0
                var greenValue: Double = 0
                var blueValue: Double = 0

                redValue = Double(hexPicker.selectedRow(inComponent: 0))
                greenValue = Double(hexPicker.selectedRow(inComponent: 1))
                blueValue = Double(hexPicker.selectedRow(inComponent: 2))


                if let hexString = hexStringParam {
                    addToDocuments(newColor: hexString)
                } else {
                    let alert = createAlert(alertReasonParam: .unknown)
                    if let presenter = alert.popoverPresentationController {
                        presenter.barButtonItem = aboutBarButtonItem
                    }
                    present(alert, animated: true)
                }


                UIView.animate(withDuration: animationDuration, animations: {
                    self.redSlider.setValue(Float(redValue / Constants.Values.rgbMax), animated: true)
                    self.greenSlider.setValue(Float(greenValue / Constants.Values.rgbMax), animated: true)
                    self.blueSlider.setValue(Float(blueValue / Constants.Values.rgbMax), animated: true)
                    self.resultView.backgroundColor = UIColor(red: CGFloat(self.redSlider.value),
                                                         green: CGFloat(self.greenSlider.value),
                                                         blue: CGFloat(self.blueSlider.value),
                                                                  alpha: 1)

                }, completion: { _ in
                    UserDefaults.standard.set(hexStringParam, forKey: Constants.UserDef.colorKey)
                    completionHandler(true)
                })

            } else {
                fatalError()
            }

    }


    // MARK: Sliders

    @IBAction func sliderChanged(_ sender: AnyObject) {
        updateColor(control: .slider)
    }


    // MARK: HEX and RGB Toggled

    @IBAction func hexAndRGBToggled() {
        let hexPickerWasSelected = UserDefaults.standard.bool(forKey: Constants.UserDef.hexPickerSelected)
        UserDefaults.standard.set(!hexPickerWasSelected, forKey: Constants.UserDef.hexPickerSelected)

        hexPicker.isHidden = hexPickerWasSelected
        rgbPicker.isHidden = !hexPickerWasSelected

        let prefixMessage = "Switch to "

        mySwitchButton.title = prefixMessage + (hexPickerWasSelected ? "HEX" : "RGB")

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
                                      attributes: [NSAttributedString.Key.foregroundColor: textColor])

        } else if pickerView.tag == 1 {
            string = rgbArray[row]
        } else {
            fatalError()
        }

        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: textColor])
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            toggleUI(enable: false)
            updateColor(control: .hexPicker) { completed in
                if completed {
                    self.toggleUI(enable: true)
                }
            }
        } else if pickerView.tag == 1 {
            toggleUI(enable: false)
            updateColor(control: .rgbPicker) { completed in
                if completed {
                    self.toggleUI(enable: true)
                }
            }
        } else {
            fatalError()
        }

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

        let copyMainAction = UIAlertAction(title: "Copy", style: .default) { _ in
            self.showCopyMainMenu()
        }

        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.showShareMainMenu()
        }

        let pasteTextAction = UIAlertAction(title: "Paste Text", style: .default) { _ in
            self.showPasteMainMenu()
        }

        let appIconAction = UIAlertAction(title: "Update App Icon", style: .default) { _ in
            self.showUpdateIconMenu()
        }

        let infoAction = UIAlertAction(title: "Contact and Info", style: .default) { _ in
            self.showInfoMainMenu()
        }

        for action in [downloadImageAction, copyMainAction, shareAction, pasteTextAction,
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


    func showCopyMainMenu() {
        let copyMainMenuAlert = UIAlertController(title: "Copy Menu", message: nil, preferredStyle: .actionSheet)

        copyMainMenuAlert.modalPresentationStyle = .popover

        let backAction = UIAlertAction(title: "Back to Main Menu", style: .default) { _ in
            self.showMainMenu()
        }

        let copyTextMainAction = UIAlertAction(title: "Copy as Text", style: .default, handler: { _ in
            self.showCopyTextMenu()
        })

        let copyImageAction = UIAlertAction(title: "Copy as Image", style: .default) { _ in
            self.copyAsImage()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        }

        for action in [backAction, copyImageAction, copyTextMainAction, cancelAction] {
            copyMainMenuAlert.addAction(action)
        }

        if let presenter = copyMainMenuAlert.popoverPresentationController {
            presenter.barButtonItem = aboutBarButtonItem
        }
            present(copyMainMenuAlert, animated: true)
    }


    func showCopyTextMenu() {
        let copyTextMenuAlert = UIAlertController(title: "Copy as Text Menu",
                                                  message: nil, preferredStyle: .actionSheet)

        copyTextMenuAlert.modalPresentationStyle = .popover

        let copyTextHexAction = UIAlertAction(title: "Copy as HEX Text", style: .default) { _ in
            self.copyAsText(format: .hex)
        }

        let copyTextRGBAction = UIAlertAction(title: "Copy as RGB Text", style: .default) { _ in
            self.copyAsText(format: .rgb)
        }

        let backAction = UIAlertAction(title: "Back to Copy Menu", style: .default) { _ in
            self.showCopyMainMenu()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        }

        for action in [backAction, copyTextHexAction, copyTextRGBAction, cancelAction] {
            copyTextMenuAlert.addAction(action)
        }

        if let presenter = copyTextMenuAlert.popoverPresentationController {
            presenter.barButtonItem = aboutBarButtonItem
        }

            present(copyTextMenuAlert, animated: true)

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


    func showPasteMainMenu() {
        let pasteMainMenuAlert = UIAlertController(title: "Paste Menu", message: nil, preferredStyle: .actionSheet)
        pasteMainMenuAlert.modalPresentationStyle = .popover

        let pasteTextHexAction = UIAlertAction(title: "Paste HEX Text", style: .default) { _ in
            self.pasteHexText()
        }

        let pasteTextRGBAction = UIAlertAction(title: "Paste RGB Text", style: .default) { _ in
            self.pasteRGBText()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        }

        let backAction = UIAlertAction(title: "Back to Main Menu", style: .default) { _ in
            self.showMainMenu()
        }

        for action in [backAction, pasteTextHexAction, pasteTextRGBAction, cancelAction] {
            pasteMainMenuAlert.addAction(action)
        }

        if let presenter = pasteMainMenuAlert.popoverPresentationController {
            presenter.barButtonItem = aboutBarButtonItem
        }

            present(pasteMainMenuAlert, animated: true)

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
            self.dismiss(animated: true, completion: {
                SKStoreReviewController.requestReview()
            })
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

        for slider in [redSlider, greenSlider, blueSlider] {
            slider?.isHidden = hide
        }
        myToolbar.isHidden = hide

        messageLabel.isHidden = !hide

        if !hide {
            _ = UserDefaults.standard.bool(
                forKey: Constants.UserDef.hexPickerSelected)
                ? (hexPicker.isHidden = false) : (rgbPicker.isHidden = false)
        } else {
            for picker in [hexPicker, rgbPicker] {
                picker?.isHidden = hide
            }
        }
        separatorView.isHidden = hide

    }


    func pasteHexText() {

        guard let pastedString = UIPasteboard.general.string else {
            let alert = createAlert(alertReasonParam: AlertReason.emptyPasteHex)
            if let presenter = alert.popoverPresentationController {
                presenter.barButtonItem = aboutBarButtonItem
            }
            present(alert, animated: true)
            return
        }

        let results = isValidHex(hex: pastedString)

        guard results.isValid else {
            let alert = createAlert(alertReasonParam: AlertReason.invalidHex, invalidCode: results.invalidHexValue)
            if let presenter = alert.popoverPresentationController {
                presenter.barButtonItem = aboutBarButtonItem
            }
            present(alert, animated: true)

            return
        }

        toggleUI(enable: false)
        updateColor(control: .pasteHex, hexStringParam: results.validHexValue) { completed in
            if completed {
                self.toggleUI(enable: true)
            }
        }

    }


    func pasteRGBText() {
        toggleUI(enable: false)

        guard let pastedString = UIPasteboard.general.string else {
            toggleUI(enable: true)
            let alert = createAlert(alertReasonParam: AlertReason.emptyPasteRGB)
            if let presenter = alert.popoverPresentationController {
                presenter.barButtonItem = aboutBarButtonItem
            }
            present(alert, animated: true)

            return
        }

        let results = isValidRGB(rgb: pastedString)

        guard results.isValid else {
            toggleUI(enable: true)
            let alert = createAlert(
                alertReasonParam: AlertReason.invalidRGB,
                invalidCode: results.invalidRgbValue)
            if let presenter = alert.popoverPresentationController {
                presenter.barButtonItem = aboutBarButtonItem
            }
            present(alert, animated: true)

            return
        }


        updateColor(control: .pasteRGB, rgbArray: results.validRgbValue) { completed in
            if completed {
                self.toggleUI(enable: true)
            }
        }

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
            toggleUI(enable: false)
            var randomHex = ""
            let randomRed = hexArray.randomElement()!
            let randomGreen = hexArray.randomElement()!
            let randomBlue = hexArray.randomElement()!

            randomHex = randomRed + randomGreen + randomBlue

            updateColor(control: .randomHex, hexStringParam: randomHex) { completed in
                if completed {
                    self.toggleUI(enable: true)
                }
            }
    }


    func addToDocuments(newColor: String) {

        // TODO: fill

    }


    @IBAction func randomHistoryPressed(_ sender: Any) {

        let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: Constants.StoryboardID.randomHistoryViewController)
            as? RandomHistoryViewController
        if let toPresent = controller {
            self.present(toPresent, animated: true)
        }
    }


    // MARK: Toogle UI

    func toggleUI(enable: Bool) {
        DispatchQueue.main.async {

            for item in [self.randomBarButtonItem, self.mySwitchButton, self.aboutBarButtonItem] {
                item?.isEnabled = enable
            }
            for slider in [self.redSlider, self.greenSlider, self.blueSlider] {
                slider?.isEnabled = enable
            }
            for picker in [self.hexPicker, self.rgbPicker] {
                picker?.isUserInteractionEnabled = enable
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
