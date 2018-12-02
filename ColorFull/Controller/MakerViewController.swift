//
//  MakerViewController.swift
//  ColorFull
//
//  Created by Dani Springer on 06/03/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI

class MakerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

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
        
        for i in 0...255 {
            hexArray.append(String(format:"%02X", i))
        }
        
        for i in 0...255 {
            rgbArray.append(String(i))
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

        redSlider.minimumTrackTintColor = UIColor.red
        greenSlider.minimumTrackTintColor = UIColor.green
        blueSlider.minimumTrackTintColor = UIColor.blue
        
        if UserDefaults.standard.string(forKey: Constants.hexPickerSelected) == nil {
            UserDefaults.standard.register(defaults: [Constants.hexPickerSelected: true])
        }

        _ = UserDefaults.standard.value(forKey: Constants.hexPickerSelected) as! Bool ? (hexPicker.isHidden = false, rgbPicker.isHidden = true) : (hexPicker.isHidden = true, rgbPicker.isHidden = false)
        
        pickersSwitch.isOn = !(UserDefaults.standard.value(forKey: Constants.hexPickerSelected) as! Bool)
        
        for toolbar in [shareToolbar, randomToolbar] {
            toolbar?.setShadowImage(UIImage.from(color: UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 0.5)), forToolbarPosition: .any)
            toolbar?.setBackgroundImage(UIImage.from(color: UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 0.5)), forToolbarPosition: .any, barMetrics: .default)
            toolbar?.layer.cornerRadius = 10
            toolbar?.layer.masksToBounds = true
        }
        
        for label in [messageLabel, hexSwitchLabel, rgbSwitchLabel] {
            label?.layer.cornerRadius = 10
            label?.layer.masksToBounds = true
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let welcomeAlert = UIAlertController(title: "Welcome", message: "For the best ColorFull experience:\n- Turn off Night Shift\n- Turn off True Tone\n- Raise your screen's brightness", preferredStyle: .actionSheet)
        
        let closeAction = UIAlertAction(title: "Don't show this again", style: .cancel) {
            _ in
            UserDefaults.standard.set(false, forKey: "isFirstLaunch")
        }
        welcomeAlert.addAction(closeAction)
        
        let remindAction = UIAlertAction(title: "Show this next time app is opened", style: .default)
        
        welcomeAlert.addAction(remindAction)
        
        if let presenter = welcomeAlert.popoverPresentationController {
            presenter.sourceView = self.shareToolbar
            presenter.sourceRect = self.shareToolbar.bounds
        }
        
        let hexString = UserDefaults.standard.string(forKey: Constants.colorKey)

        UIView.animate(withDuration: 0.5, animations: {
            self.redSlider.setValue(Float("0x" + hexString![0...1])! / 255, animated: true)
            self.greenSlider.setValue(Float("0x" + hexString![2...3])! / 255, animated: true)
            self.blueSlider.setValue(Float("0x" + hexString![4...5])! / 255, animated: true)
            
            let redHex = hexString![0...1]
            let greenHex = hexString![2...3]
            let blueHex = hexString![4...5]
            
            let redIndexHex = self.hexArray.index(of: String(redHex))
            let greenIndexHex = self.hexArray.index(of: String(greenHex))
            let blueIndexHex = self.hexArray.index(of: String(blueHex))
            
            self.hexPicker.selectRow(redIndexHex!, inComponent: 0, animated: true)
            self.hexPicker.selectRow(greenIndexHex!, inComponent: 1, animated: true)
            self.hexPicker.selectRow(blueIndexHex!, inComponent: 2, animated: true)
            
            let redIndexRGB = Int(hexString![0...1], radix: 16)
            let greenIndexRGB = Int(hexString![2...3], radix: 16)
            let blueIndexRGB = Int(hexString![4...5], radix: 16)
            
            self.rgbPicker.selectRow(redIndexRGB!, inComponent: 0, animated: true)
            self.rgbPicker.selectRow(greenIndexRGB!, inComponent: 1, animated: true)
            self.rgbPicker.selectRow(blueIndexRGB!, inComponent: 2, animated: true)
            
            self.view.backgroundColor = UIColor(red: CGFloat(self.redSlider.value), green: CGFloat(self.greenSlider.value), blue: CGFloat(self.blueSlider.value), alpha: 1)
        }, completion: {
            _ in
            if UserDefaults.standard.bool(forKey: "isFirstLaunch") {
                self.present(welcomeAlert, animated: true)
            }
        })
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    
    // MARK: Update Color
    
    func updateColor(control: Controls, hexStringParam: String? = nil, rgbArray: [Int] = [], completionHandler: @escaping (Bool) -> Void = {_ in return }) {
        
        if control == .slider {
            
            let r: CGFloat = CGFloat(self.redSlider.value)
            let g: CGFloat = CGFloat(self.greenSlider.value)
            let b: CGFloat = CGFloat(self.blueSlider.value)
            
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
            
            self.rgbPicker.selectRow(rBase255, inComponent: 0, animated: true)
            self.rgbPicker.selectRow(gBase255, inComponent: 1, animated: true)
            self.rgbPicker.selectRow(bBase255, inComponent: 2, animated: true)
            
            let hexCode = redHex + greenHex + blueHex
            UserDefaults.standard.set(hexCode, forKey: Constants.colorKey)
            
        } else if control == .hexPicker {
            let redValue: Float = Float(hexPicker.selectedRow(inComponent: 0))
            let greenValue: Float = Float(hexPicker.selectedRow(inComponent: 1))
            let blueValue: Float = Float(hexPicker.selectedRow(inComponent: 2))
            
            UIView.animate(withDuration: 0.5, animations: {
                self.redSlider.setValue(Float(redValue / 255.0), animated: true)
                self.greenSlider.setValue(Float(greenValue / 255.0), animated: true)
                self.blueSlider.setValue(Float(blueValue / 255.0), animated: true)
                self.view.backgroundColor = UIColor(red: CGFloat(self.redSlider.value), green: CGFloat(self.greenSlider.value), blue: CGFloat(self.blueSlider.value), alpha: 1)
            })
            
            let redHex = hexArray[hexPicker.selectedRow(inComponent: 0)]
            let greenHex = hexArray[hexPicker.selectedRow(inComponent: 1)]
            let blueHex = hexArray[hexPicker.selectedRow(inComponent: 2)]
            
            self.rgbPicker.selectRow(Int(redValue), inComponent: 0, animated: true)
            self.rgbPicker.selectRow(Int(greenValue), inComponent: 1, animated: true)
            self.rgbPicker.selectRow(Int(blueValue), inComponent: 2, animated: true)
            
            let hexCode = redHex + greenHex + blueHex
            UserDefaults.standard.set(hexCode, forKey: Constants.colorKey)
            
        } else if control == .rgbPicker {
            let redValue: Double = Double(rgbPicker.selectedRow(inComponent: 0))
            let greenValue: Double = Double(rgbPicker.selectedRow(inComponent: 1))
            let blueValue: Double = Double(rgbPicker.selectedRow(inComponent: 2))
            
            self.hexPicker.selectRow(Int(redValue), inComponent: 0, animated: true)
            self.hexPicker.selectRow(Int(greenValue), inComponent: 1, animated: true)
            self.hexPicker.selectRow(Int(blueValue), inComponent: 2, animated: true)
            
            let redHex = String(format: "%02X", redValue)
            let greenHex = String(format: "%02X", greenValue)
            let blueHex = String(format: "%02X", blueValue)
            
            let hexCode = redHex + greenHex + blueHex
            
            UIView.animate(withDuration: 0.5, animations: {
                self.redSlider.setValue(Float(redValue / 255.0), animated: true)
                self.greenSlider.setValue(Float(greenValue / 255.0), animated: true)
                self.blueSlider.setValue(Float(blueValue / 255.0), animated: true)
                self.view.backgroundColor = UIColor(red: CGFloat(self.redSlider.value), green: CGFloat(self.greenSlider.value), blue: CGFloat(self.blueSlider.value), alpha: 1)
            }, completion: { (finished: Bool) in
                print(hexCode)
                UserDefaults.standard.set(hexCode, forKey: Constants.colorKey)
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
                self.redSlider.setValue(Float(redValue / 255.0), animated: true)
                self.greenSlider.setValue(Float(greenValue / 255.0), animated: true)
                self.blueSlider.setValue(Float(blueValue / 255.0), animated: true)
                self.view.backgroundColor = UIColor(red: CGFloat(self.redSlider.value), green: CGFloat(self.greenSlider.value), blue: CGFloat(self.blueSlider.value), alpha: 1)
            }, completion: { (finished: Bool) in
                
                UserDefaults.standard.set(hexStringParam, forKey: Constants.colorKey)
                completionHandler(true)
            })
            
        } else if control == .pasteRGB {
            
            let redValue = rgbArray[0]
            let greenValue = rgbArray[1]
            let blueValue = rgbArray[2]
            
            let redHex = String(format: "%02X", redValue)
            let greenHex = String(format: "%02X", greenValue)
            let blueHex = String(format: "%02X", blueValue)
            
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
                self.redSlider.setValue(Float(Double(redValue) / 255.0), animated: true)
                self.greenSlider.setValue(Float(Double(greenValue) / 255.0), animated: true)
                self.blueSlider.setValue(Float(Double(blueValue) / 255.0), animated: true)
                self.view.backgroundColor = UIColor(red: CGFloat(self.redSlider.value), green: CGFloat(self.greenSlider.value), blue: CGFloat(self.blueSlider.value), alpha: 1)
            }, completion: { (finished: Bool) in
                UserDefaults.standard.set(hexString, forKey: Constants.colorKey)
                completionHandler(true)
            })
            
        } else {
            fatalError()
        }
        
    }
    
    
    // MARK: Sliders
    
    @IBAction func sliderChanged(_ sender: AnyObject) {
        
        // Call color changing func
        updateColor(control: Controls.slider)
        
    }
    
    
    // MARK: Picker Switch
    
    @IBAction func pickerSwitchToggled(_ sender: Any) {
        UserDefaults.standard.set(!pickersSwitch.isOn, forKey: Constants.hexPickerSelected)
        _ = pickersSwitch.isOn ? (hexPicker.isHidden = true, rgbPicker.isHidden = false) : (hexPicker.isHidden = false, rgbPicker.isHidden = true)
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
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var string = ""
        
        if pickerView.tag == 0 {
            string = hexArray[row]
            return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
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
    
    @IBAction func shareToolbarPressed(_ sender: Any) {
        
        let mainAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let copyMainAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let copyTextAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareMainAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareTextAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let pasteAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let version: String? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let infoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let version = version {
            infoAlert.message = "Version \(version)"
            infoAlert.title = "ColorFull"
        }
        
        for alert in [mainAlert, copyMainAlert, copyTextAlert, shareMainAlert, shareTextAlert, pasteAlert, infoAlert] {
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
        
        let copyTextHexAction = UIAlertAction(title: "Copy as HEX text", style: .default) {
            _ in
            self.copyAsText(format: .hex)
            
        }
        
        let copyTextRGBAction = UIAlertAction(title: "Copy as RGB text", style: .default) {
            _ in
            self.copyAsText(format: .rgb)
        }
        
        for action in [copyTextHexAction, copyTextRGBAction,cancelAction] {
            copyTextAlert.addAction(action)
        }
        
        let copyTextMainAction = UIAlertAction(title: "Copy as text", style: .default, handler: {
            _ in
            if let presenter = copyMainAlert.popoverPresentationController {
                presenter.sourceView = self.shareToolbar
                presenter.sourceRect = self.shareToolbar.bounds
            }
            self.present(copyTextAlert, animated: true)
        })
        
        let copyImageAction = UIAlertAction(title: "Copy as image", style: .default) {
            _ in
            self.copyHexAndColorAsImage()
        }
        
        for action in [copyImageAction, copyTextMainAction, cancelAction] {
            copyMainAlert.addAction(action)
        }
        
        let copyMainAction = UIAlertAction(title: "Copy", style: .default) {
            _ in
            
            if let presenter = copyMainAlert.popoverPresentationController {
                presenter.sourceView = self.shareToolbar
                presenter.sourceRect = self.shareToolbar.bounds
            }
            self.present(copyMainAlert, animated: true)
        }
        
        let shareTextHexAction = UIAlertAction(title: "Share as HEX text", style: .default) {
            _ in
            self.shareColorAsText(format: .hex)
        }
        
        let shareTextRGBAction = UIAlertAction(title: "Share as RGB text", style: .default) {
            _ in
            self.shareColorAsText(format: .rgb)
        }
        
        for action in [shareTextHexAction, shareTextRGBAction, cancelAction] {
            shareTextAlert.addAction(action)
        }
        
        let shareTextMainAction = UIAlertAction(title: "Share as text", style: .default) {
            _ in
            if let presenter = copyMainAlert.popoverPresentationController {
                presenter.sourceView = self.shareToolbar
                presenter.sourceRect = self.shareToolbar.bounds
            }
            self.present(shareTextAlert, animated: true)
        }
        
        let shareImageAction = UIAlertAction(title: "Share as image", style: .default) {
            _ in
            self.shareHexAndColorAsImage()
        }
        
        for action in [shareImageAction, shareTextMainAction, cancelAction] {
            shareMainAlert.addAction(action)
        }
        
        let shareAction = UIAlertAction(title: "Share", style: .default) {
            _ in
            
            if let presenter = shareMainAlert.popoverPresentationController {
                presenter.sourceView = self.shareToolbar
                presenter.sourceRect = self.shareToolbar.bounds
            }
            self.present(shareMainAlert, animated: true)
        }
        
        let pasteTextHexAction = UIAlertAction(title: "Paste HEX text", style: .default) {
            _ in
            self.pasteHexText()
        }
        
        let pasteTextRGBAction = UIAlertAction(title: "Paste RGB text", style: .default) {
            _ in
            self.pasteRGBText()
        }
        
        for action in [pasteTextHexAction, pasteTextRGBAction, cancelAction] {
            pasteAlert.addAction(action)
        }
        
        let pasteTextAction = UIAlertAction(title: "Paste text", style: .default) {
            _ in
            // present paste menu
            if let presenter = pasteAlert.popoverPresentationController {
                presenter.sourceView = self.shareToolbar
                presenter.sourceRect = self.shareToolbar.bounds
            }
            self.present(pasteAlert, animated: true)
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
                presenter.sourceView = self.shareToolbar
                presenter.sourceRect = self.shareToolbar.bounds
            }
            self.present(infoAlert, animated: true)
        }
        
        for action in [downloadImageAction, copyMainAction, shareAction, pasteTextAction, infoAction, cancelAction] {
            mainAlert.addAction(action)
        }
        
        if let presenter = mainAlert.popoverPresentationController {
            presenter.sourceView = shareToolbar
            presenter.sourceRect = shareToolbar.bounds
        }
        
        present(mainAlert, animated: true)

    }
    
    
    // MARK: Random Toolbar

    @IBAction func randomPressed(_ sender: Any) {
        toggleUI(enable: false)
        var randomHex = ""
        let randomRed = hexArray.randomElement()!
        let randomGreen = hexArray.randomElement()!
        let randomBlue = hexArray.randomElement()!
        
        randomHex = randomRed + randomGreen + randomBlue
        
        updateColor(control: .pasteHexOrRandomHex, hexStringParam: randomHex) {
            completed in
            if completed {
                self.toggleUI(enable: true)
            }
        }
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
    
    
    func copyAsText(format: Format) {
        
        let pasteboard = UIPasteboard.general
        
        switch format {
        case .hex:
            pasteboard.string = UserDefaults.standard.string(forKey: Constants.colorKey)
        case .rgb:
            
            let hexString = UserDefaults.standard.string(forKey: Constants.colorKey)

            let redValue = Int(hexString![0...1], radix: 16)!
            let greenValue = Int(hexString![2...3], radix: 16)!
            let blueValue = Int(hexString![4...5], radix: 16)!
            
            pasteboard.string = "\(redValue),\(greenValue),\(blueValue)"
            
        }
        
        let alert = createAlert(alertReasonParam: alertReason.textCopied, format: format)
        present(alert, animated: true)
    }
    
    
    func copyHexAndColorAsImage() {
        
        let image = generateHexImage()
        let pasteboard = UIPasteboard.general
        pasteboard.image = image
        
        let alert = createAlert(alertReasonParam: alertReason.imageCopied)
        present(alert, animated: true)
    }
    
    
    func shareColorAsText(format: Format) {
        
        var myText = ""
        
        switch format {
        case .hex:
            myText = UserDefaults.standard.string(forKey: Constants.colorKey)!
        case .rgb:
            let hexString = UserDefaults.standard.string(forKey: Constants.colorKey)

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
    
            for slider in [redSlider, greenSlider, blueSlider] {
                slider?.isHidden = true
            }

            let hexPickerWasHidden = hexPicker.isHidden
            
            for picker in [hexPicker, rgbPicker] {
                picker?.isHidden = true
            }
            
            for toolbar in [shareToolbar, randomToolbar] {
                toolbar?.isHidden = true
            }
            
            for label in [hexSwitchLabel, rgbSwitchLabel] {
                label?.isHidden = true
            }
            
            pickersSwitch.isHidden = true
            
            let regularAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16)]
            
            let jumboAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 50)]
            
            let attributedMessagePreHex = NSAttributedString(string: "\nThe HEX value for your color is:\n", attributes: regularAttributes)
            
            let hexString = UserDefaults.standard.string(forKey: Constants.colorKey) ?? "<error>"
            
            let attributedMessageJumboHex = NSAttributedString(string: hexString, attributes: jumboAttributes)
            
            let attributedMessagePreRGB = NSAttributedString(string: "\n\nThe RGB value for your color is:\n", attributes: regularAttributes)

            let redValue = Int(hexString[0...1], radix: 16)!
            let greenValue = Int(hexString[2...3], radix: 16)!
            let blueValue = Int(hexString[4...5], radix: 16)!
            
            let rgbString = "\(redValue),\(greenValue),\(blueValue)"
            
            let attributedMessageJumboRGB = NSAttributedString(string: rgbString, attributes: jumboAttributes)
            
            let attributedMessagePost = NSAttributedString(string: "\n\nCreated using:\nColorFull by Daniel Springer\nAvailable exclusively on the iOS App Store\n", attributes: regularAttributes)
            
            let myAttributedText = NSMutableAttributedString()
            
            myAttributedText.append(attributedMessagePreHex)
            myAttributedText.append(attributedMessageJumboHex)
            myAttributedText.append(attributedMessagePreRGB)
            myAttributedText.append(attributedMessageJumboRGB)
            myAttributedText.append(attributedMessagePost)
            
            messageLabel.attributedText = myAttributedText
            messageLabel.isHidden = false
            UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0.0)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let hexImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            messageLabel.isHidden = true

            for slider in [redSlider, greenSlider, blueSlider] {
                slider?.isHidden = false
            }
            
            _ = hexPickerWasHidden ? (rgbPicker.isHidden = false) : (hexPicker.isHidden = false)
            
            for toolbar in [shareToolbar, randomToolbar] {
                toolbar?.isHidden = false
            }
            
            for label in [hexSwitchLabel, rgbSwitchLabel] {
                label?.isHidden = false
            }
            
            pickersSwitch.isHidden = false
    
            return hexImage
        }
    
    
    func pasteHexText() {

        guard let pastedString = UIPasteboard.general.string else {
            let alert = createAlert(alertReasonParam: alertReason.emptyPasteHex)
            present(alert, animated: true)
            return
        }
        
        let results = isValidHex(hex: pastedString)
        
        guard results.0 else {
            let alert = createAlert(alertReasonParam: alertReason.invalidHex, invalidCode: results.1)
            present(alert, animated: true)
            return
        }
        
        updateColor(control: Controls.pasteHexOrRandomHex, hexStringParam: results.1)
        let alert = createAlert(alertReasonParam: alertReason.hexPasted)
        present(alert, animated: true)
        
    }
    
    
    func pasteRGBText() {

        guard let pastedString = UIPasteboard.general.string else {
            let alert = createAlert(alertReasonParam: alertReason.emptyPasteRGB)
            present(alert, animated: true)
            return
        }
        let results = isValidRGB(rgb: pastedString)
        
        guard results.0 else {
            let alert = createAlert(alertReasonParam: alertReason.invalidRGB, invalidCode: results.1)
            present(alert, animated: true)
            return
        }

        updateColor(control: Controls.pasteRGB, rgbArray: results.2)
        let alert = createAlert(alertReasonParam: alertReason.RGBPasted)
        present(alert, animated: true)
    }
    
    
    func isValidHex(hex: String) -> (Bool, String) {
        
        let uppercasedDirtyHex = hex.uppercased()
        
        let cleanedHex = uppercasedDirtyHex.filter {
            "ABCDEF0123456789".contains($0)
        }
        
        guard cleanedHex.count == 6 else {
            return (false, hex)
        }

        return (true, cleanedHex)
    }
    
    // n,n,n
    // then, if practical, more formats: spaces, letters, percentages, dots
    // if more are added, update filter
    // return values that are more similar to input
    func isValidRGB(rgb: String) -> (Bool, String, [Int]) {

        let cleanedRGB = rgb.filter {
            "0123456789,".contains($0)
        }
        print(cleanedRGB)
        
        let stringsArray = cleanedRGB.split(separator: ",")
        print(stringsArray)
        let intsArray: [Int] = stringsArray.map { Int($0)!}
        print(intsArray)
        
        guard Array(intsArray).count >= 3 else {
            return (false, "", Array(intsArray))
        }
        
        let firstThreeValues = Array(intsArray[0...2])
        print(firstThreeValues)

        guard firstThreeValues.allSatisfy({ (0...255).contains($0) }) else {
            return (false, rgb, firstThreeValues)
        }
        
        return (true, "", firstThreeValues)
    }
    
    
    func shareApp() {
        
        let message = "Look at this app: ColorFull lets you generate a color from millions of choices using sliders or HEX code, and save or share your created color! https://itunes.apple.com/app/id1410565176 - it's really cool!"
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
        
        var emailTitle = "ColorFull"
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


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
