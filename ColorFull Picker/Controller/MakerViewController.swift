//
//  MakerViewController.swift
//  Color Picker
//
//  Created by Dani Springer on 06/03/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI

class MakerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    // MARK: Outlets
    
    @IBOutlet weak var redControl: UISlider!
    @IBOutlet weak var greenControl: UISlider!
    @IBOutlet weak var blueControl: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var hexPicker: UIPickerView!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var menuToolbar: UIToolbar!
    
    // MARK: properties
    
    let myDataSource = ["Download as image", "Copy as text", "Copy as image", "Share as text", "Share as image", "Paste text", "Contact and info"]
    
    enum Controls {
        case slider
        case picker
        case paste
    }
    
    var currentUIColor: UIColor!
    var currentHexColor: String!
    
    var hexArray: [String] = []
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...255 {
            hexArray.append(String(format:"%02X", i))
        }
        
        hexPicker.delegate = self
        
        hexLabel.isHidden = true
        creditLabel.isHidden = true
        
        UIScreen.main.brightness = 1.0
        
        redControl.thumbTintColor = .red
        greenControl.thumbTintColor = .green
        blueControl.thumbTintColor = .blue

        redControl.minimumTrackTintColor = UIColor.red
        greenControl.minimumTrackTintColor = UIColor.green
        blueControl.minimumTrackTintColor = UIColor.blue
        
        if UserDefaults.standard.string(forKey: "color") == nil {
            UserDefaults.standard.register(defaults: ["color": "E57BF2"])
        }
        
        menuToolbar.setShadowImage(UIImage.from(color: UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 0.5)), forToolbarPosition: .any)
        menuToolbar.setBackgroundImage(UIImage.from(color: UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 0.5)), forToolbarPosition: .any, barMetrics: .default)
        menuToolbar.layer.cornerRadius = 10
        menuToolbar.layer.masksToBounds = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        subscribeToBrightnessNotifications()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let hexString = UserDefaults.standard.string(forKey: "color")
        
        UIView.animate(withDuration: 0.5, animations: {
            self.redControl.setValue(Float("0x" + hexString![0...1])! / 255, animated: true)
            self.greenControl.setValue(Float("0x" + hexString![2...3])! / 255, animated: true)
            self.blueControl.setValue(Float("0x" + hexString![4...5])! / 255, animated: true)
            
            let redHex = hexString![0...1]
            let greenHex = hexString![2...3]
            let blueHex = hexString![4...5]
            
            let redIndex = self.hexArray.index(of: String(redHex))
            let greenIndex = self.hexArray.index(of: String(greenHex))
            let blueIndex = self.hexArray.index(of: String(blueHex))
            
            self.hexPicker.selectRow(redIndex!, inComponent: 0, animated: true)
            self.hexPicker.selectRow(greenIndex!, inComponent: 1, animated: true)
            self.hexPicker.selectRow(blueIndex!, inComponent: 2, animated: true)
            
            self.brightnessSlider.setValue(1.0, animated: true)
            
            self.view.backgroundColor = UIColor(red: CGFloat(self.redControl.value), green: CGFloat(self.greenControl.value), blue: CGFloat(self.blueControl.value), alpha: 1)
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromBrightnessNotifications()
    }
    
    
    // MARK: Helper
    
    func updateColor(control: Controls, hexString: String = "") {
        
        if control == .slider {
            
            let r: CGFloat = CGFloat(self.redControl.value)
            let g: CGFloat = CGFloat(self.greenControl.value)
            let b: CGFloat = CGFloat(self.blueControl.value)
            
            view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
            
            let rBase255 = Int(r * 255)
            let gBase255 = Int(g * 255)
            let bBase255 = Int(b * 255)
            let redHex = String(format: "%02X", rBase255)
            let greenHex = String(format: "%02X", gBase255)
            let blueHex = String(format: "%02X", bBase255)

            let redIndex = hexArray.index(of: redHex)
            let greenIndex = hexArray.index(of: greenHex)
            let blueIndex = hexArray.index(of: blueHex)
            
            hexPicker.selectRow(redIndex!, inComponent: 0, animated: true)
            hexPicker.selectRow(greenIndex!, inComponent: 1, animated: true)
            hexPicker.selectRow(blueIndex!, inComponent: 2, animated: true)
            let hexCode = redHex + greenHex + blueHex
            UserDefaults.standard.set(hexCode, forKey: "color")
            
        } else if control == .picker {
            let redValue: Double = Double(hexPicker.selectedRow(inComponent: 0))
            let greenValue: Double = Double(hexPicker.selectedRow(inComponent: 1))
            let blueValue: Double = Double(hexPicker.selectedRow(inComponent: 2))
            
            UIView.animate(withDuration: 0.5, animations: {
                self.redControl.setValue(Float(redValue / 255.0), animated: true)
                self.greenControl.setValue(Float(greenValue / 255.0), animated: true)
                self.blueControl.setValue(Float(blueValue / 255.0), animated: true)
                self.view.backgroundColor = UIColor(red: CGFloat(self.redControl.value), green: CGFloat(self.greenControl.value), blue: CGFloat(self.blueControl.value), alpha: 1)
            })

            
            let redHex = hexArray[hexPicker.selectedRow(inComponent: 0)]
            let greenHex = hexArray[hexPicker.selectedRow(inComponent: 1)]
            let blueHex = hexArray[hexPicker.selectedRow(inComponent: 2)]
            let hexCode = redHex + greenHex + blueHex
            UserDefaults.standard.set(hexCode, forKey: "color")
            
        } else if control == .paste {
            let redString = hexString[0...1]
            let greenString = hexString[2...3]
            let blueString = hexString[4...5]
            
            let redIndex = hexArray.index(of: String(redString))
            let greenIndex = hexArray.index(of: String(greenString))
            let blueIndex = hexArray.index(of: String(blueString))
            
            hexPicker.selectRow(redIndex!, inComponent: 0, animated: true)
            hexPicker.selectRow(greenIndex!, inComponent: 1, animated: true)
            hexPicker.selectRow(blueIndex!, inComponent: 2, animated: true)
            
            let redValue: Double = Double(hexPicker.selectedRow(inComponent: 0))
            let greenValue: Double = Double(hexPicker.selectedRow(inComponent: 1))
            let blueValue: Double = Double(hexPicker.selectedRow(inComponent: 2))
            
            UIView.animate(withDuration: 0.5, animations: {
                self.redControl.setValue(Float(redValue / 255.0), animated: true)
                self.greenControl.setValue(Float(greenValue / 255.0), animated: true)
                self.blueControl.setValue(Float(blueValue / 255.0), animated: true)
                self.view.backgroundColor = UIColor(red: CGFloat(self.redControl.value), green: CGFloat(self.greenControl.value), blue: CGFloat(self.blueControl.value), alpha: 1)
            })
            
            UserDefaults.standard.set(hexString, forKey: "color")
        } else {
            fatalError()
        }
        
    }
    
    
    // MARK: Sliders
    
    @IBAction func sliderChanged(_ sender: AnyObject) {
        
        // Call color changing func
        updateColor(control: Controls.slider)
        
    }
    
    
    @objc func updateBrightness(_ notification:Notification) {
        brightnessSlider.value = Float(UIScreen.main.brightness)
    }
    
    
    @IBAction func brightnessChanged() {
        UIScreen.main.brightness = CGFloat(brightnessSlider.value)
    }
    
    
    // MARK: Pickers
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return 3
        } else {
            fatalError()
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return hexArray.count
        } else {
            fatalError()
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = hexArray[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            updateColor(control: Controls.picker)
        } else {
            fatalError()
        }
        
    }

    
    // MARK: Menu Options
    
    @IBAction func menuPressed(_ sender: Any) {
        
        let mainAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let copyAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let version: String? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let infoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let version = version {
            infoAlert.message = "Version \(version)"
            infoAlert.title = "ColorFull Picker"
        }
        
        for alert in [mainAlert, copyAlert, shareAlert, infoAlert] {
            alert.modalPresentationStyle = .popover
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            _ in
            self.dismiss(animated: true, completion: {
                SKStoreReviewController.requestReview()
            })
        }
        
        let downloadImageAction = UIAlertAction(title: "Download as image", style: .default, handler: {
            _ in
            self.downloadHexAndColor()
        })
        
        let copyTextAction = UIAlertAction(title: "Copy as text", style: .default, handler: {
            _ in
            self.copyHexAsText()
        })
        
        let copyImageAction = UIAlertAction(title: "Copy as image", style: .default) {
            _ in
            self.copyHexAndColorAsImage()
        }
        
        for action in [copyImageAction, copyTextAction, cancelAction] {
            copyAlert.addAction(action)
        }
        
        let copyAction = UIAlertAction(title: "Copy", style: .default) {
            _ in
            
            if let presenter = copyAlert.popoverPresentationController {
                presenter.sourceView = self.menuToolbar
                presenter.sourceRect = self.menuToolbar.bounds
            }
            self.present(copyAlert, animated: true)
        }
        
        let shareTextAction = UIAlertAction(title: "Share as text", style: .default) {
            _ in
            self.shareHexAsText()
        }
        
        let shareImageAction = UIAlertAction(title: "Share as image", style: .default) {
            _ in
            self.shareHexAndColorAsImage()
        }
        
        for action in [shareImageAction, shareTextAction, cancelAction] {
            shareAlert.addAction(action)
        }
        
        let shareAction = UIAlertAction(title: "Share", style: .default) {
            _ in
            
            if let presenter = shareAlert.popoverPresentationController {
                presenter.sourceView = self.menuToolbar
                presenter.sourceRect = self.menuToolbar.bounds
            }
            self.present(shareAlert, animated: true)
        }
        
        let pasteTextAction = UIAlertAction(title: "Paste text", style: .default) {
            _ in
            self.pasteText()
        }
        
        let mailAction = UIAlertAction(title: "Send feedback or question", style: .default) {
            _ in
            self.launchEmail()
        }
        
        let reviewAction = UIAlertAction(title: "Leave a review", style: .default) {
            _ in
            self.requestReviewManually()
        }
        
        let shareAppAction = UIAlertAction(title: "Share App with friends", style: .default) {
            _ in
            self.shareApp()
        }
        
        for action in [mailAction, reviewAction, shareAppAction, cancelAction] {
            infoAlert.addAction(action)
        }
        
        let infoAction = UIAlertAction(title: "Contact and info", style: .default) {
            _ in
            
            if let presenter = infoAlert.popoverPresentationController {
                presenter.sourceView = self.menuToolbar
                presenter.sourceRect = self.menuToolbar.bounds
            }
            self.present(infoAlert, animated: true)
        }
        
        for action in [downloadImageAction, copyAction, shareAction, pasteTextAction, infoAction, cancelAction] {
            mainAlert.addAction(action)
        }
        
        if let presenter = mainAlert.popoverPresentationController {
            presenter.sourceView = menuToolbar
            presenter.sourceRect = menuToolbar.bounds
        }
        
        present(mainAlert, animated: true)

    }

    
    func downloadHexAndColor() {
        
        let image = generateHexImage()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            let alert = createAlert(alertReasonParam: alertReason.permissionDenied)
            let goToSettingsButton = UIAlertAction(title: "Open Settings", style: .default, handler: {
                action in
                if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
                    UIApplication.shared.open(url)
                }
            })
            alert.addAction(goToSettingsButton)
            present(alert, animated: true)
            return
        }
        let alert = createAlert(alertReasonParam: alertReason.imageSaved)
        let goToLibraryButton = UIAlertAction(title: "Open Gallery", style: .default, handler: {
            action in
            UIApplication.shared.open(URL(string:"photos-redirect://")!)
        })
        alert.addAction(goToLibraryButton)
        present(alert, animated: true)
    }
    
    
    func copyHexAsText() {

        let pasteboard = UIPasteboard.general
        pasteboard.string = UserDefaults.standard.string(forKey: "color")
        
        let alert = createAlert(alertReasonParam: alertReason.hexSaved)
        present(alert, animated: true)
    }
    
    
    func copyHexAndColorAsImage() {
        
        let image = generateHexImage()
        let pasteboard = UIPasteboard.general
        pasteboard.image = image
        
        let alert = createAlert(alertReasonParam: alertReason.imageCopied)
        present(alert, animated: true)
    }
    
    
    func shareHexAsText() {
        
        let myText = UserDefaults.standard.string(forKey: "color")!

        let activityController = UIActivityViewController(activityItems: [myText], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown)
                self.present(alert, animated: true)
                return
            }
        }
        present(activityController, animated: true)

    }
    
    
    func shareHexAndColorAsImage() {
        
        let image = generateHexImage()
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown)
                self.present(alert, animated: true)
                return
            }
        }
        present(activityController, animated: true)
    }
    
    
        func generateHexImage() -> UIImage {
    
            for slider in [redControl, greenControl, blueControl, brightnessSlider] {
                slider?.isHidden = true
            }

            hexPicker.isHidden = true
            menuToolbar.isHidden = true
            
            hexLabel.text = UserDefaults.standard.string(forKey: "color")
            hexLabel.isHidden = false
            creditLabel.isHidden = false
            UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0.0)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let hexImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            hexLabel.isHidden = true
            creditLabel.isHidden = true

            for slider in [redControl, greenControl, blueControl, brightnessSlider] {
                slider?.isHidden = false
            }

            hexPicker.isHidden = false
            menuToolbar.isHidden = false
    
            return hexImage
        }
    
    
    func pasteText() {
        // check if valid hex code
        guard let pastedString = UIPasteboard.general.string else {
            let alert = createAlert(alertReasonParam: alertReason.emptyPaste)
            present(alert, animated: true)
            return
        }
        
        let results = isValidHex(hex: pastedString)
        
        guard results.0 else {
            let alert = createAlert(alertReasonParam: alertReason.invalidHex, invalidHex: results.1)
            present(alert, animated: true)
            print("invalid hex")
            return
        }
        
        print("valid hex")
        updateColor(control: Controls.paste, hexString: results.1)
        let alert = createAlert(alertReasonParam: alertReason.hexPasted)
        present(alert, animated: true)
        
    }
    
    
    func isValidHex(hex: String) -> (Bool, String) {
        
        guard hex.count == 6 else {
            return (false, hex)
        }
        
        let uppercased = hex.uppercased()
        let trimmedFromSpaces = uppercased.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedFromPound = trimmedFromSpaces.replacingOccurrences(of: "#", with: "")
        let cleanedFromSymbols = cleanedFromPound.trimmingCharacters(in: .punctuationCharacters)
        
        let validHexChars = "ABCDEF0123456789"
        
        for char in cleanedFromSymbols {
            if !validHexChars.contains(char) {
                print("invalid hex: \(char)")
                return (false, hex)
            }
        }
    
        return (true, cleanedFromSymbols)
    }
    
    
    func shareApp() {
        
        let message = "Look at this app: ColorFull Picker lets you generate a color from millions of choices using sliders or HEX code, and save or share your created color! https://itunes.apple.com/app/id1410565176 - it's really cool!"
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.modalPresentationStyle = .popover
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown)
                self.present(alert, animated: true)
                return
            }
        }
        if let presenter = activityController.popoverPresentationController {
            presenter.sourceView = menuToolbar
            presenter.sourceRect = menuToolbar.bounds
        }
        
        present(activityController, animated: true)
    }
    
    
    // MARK: Notifications
    
    func subscribeToBrightnessNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateBrightness(_:)), name: UIScreen.brightnessDidChangeNotification, object: nil)
    }
    
    
    func unsubscribeFromBrightnessNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIScreen.brightnessDidChangeNotification, object: nil)
    }
    
}


extension MakerViewController: MFMailComposeViewControllerDelegate {
    
    func launchEmail() {
        
        var emailTitle = "ColorFull Picker"
        if let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] {
            emailTitle += " \(version)"
        }
        
        let messageBody = "Hi. I have a question..."
        let toRecipents = ["musicbyds@icloud.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var alert = UIAlertController()
        
        dismiss(animated: true, completion: {
            switch result {
            case MFMailComposeResult.failed:
                alert = self.createAlert(alertReasonParam: alertReason.messageFailed)
            case MFMailComposeResult.saved:
                alert = self.createAlert(alertReasonParam: alertReason.messageSaved)
            case MFMailComposeResult.sent:
                alert = self.createAlert(alertReasonParam: alertReason.messageSent)
            default:
                break
            }
            if let _ = alert.title {
                self.present(alert, animated: true)
            }
        })
    }
}

extension MakerViewController {
    
    func requestReviewManually() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL
        
        guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id1410565176?action=write-review")
            else {
                fatalError("Expected a valid URL")
        }
        
        UIApplication.shared.open(writeReviewURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
