//
//  MakerViewController.swift
//  Color Picker
//
//  Created by Dani Springer on 06/03/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import StoreKit

class MakerViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var redControl: UISlider!
    @IBOutlet weak var greenControl: UISlider!
    @IBOutlet weak var blueControl: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var hexTextField: UITextField!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var menuStackView: UIStackView!
    @IBOutlet weak var menuButton: KeyboardButton!
    @IBOutlet weak var keyboardStackView: UIStackView!
    
    

    // MARK: properties
    
    var currentUIColor: UIColor!
    var currentHexColor: String!
    var timer: Timer!
    var brightnessFractionToAdd: CGFloat!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subscribeToBrightnessNotifications()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hexTextField.isEnabled = false
        menuStackView.isHidden = true
        subView.isHidden = true
        subView.layer.borderColor = UIColor.white.cgColor
        subView.layer.borderWidth = 5
        subView.layer.cornerRadius = 10
        subView.layer.shadowOffset = CGSize(width: -20, height: 15)
        subView.layer.shadowRadius = 10
        subView.layer.shadowOpacity = 0.6
        brightnessSlider.setThumbImage(UIImage(named: "brightness.png"), for: .normal)
        brightnessSlider.setThumbImage(UIImage(named: "brightness.png"), for: .highlighted)
        
        let initialBrightness = UIScreen.main.brightness
        let brightnessMissing = 1.0 - initialBrightness
        brightnessFractionToAdd = brightnessMissing / 20.0
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.animateBrightness), userInfo: nil, repeats: true)

        redControl.minimumTrackTintColor = UIColor.red
        greenControl.minimumTrackTintColor = UIColor.green
        blueControl.minimumTrackTintColor = UIColor.blue
        
        redControl.setThumbImage(SliderIcon.red , for: .normal)
        redControl.setThumbImage(SliderIcon.red, for: .highlighted)
        
        greenControl.setThumbImage(SliderIcon.green, for: .normal)
        greenControl.setThumbImage(SliderIcon.green, for: .highlighted)
        
        blueControl.setThumbImage(SliderIcon.blue, for: .normal)
        blueControl.setThumbImage(SliderIcon.blue, for: .highlighted)
        
        if UserDefaults.standard.string(forKey: "color") == nil {
            UserDefaults.standard.register(defaults: ["color": "E57BF2"])
        }
        
        hexTextField.text = UserDefaults.standard.string(forKey: "color")
        
        // update controls with animation
        let redHex = Float("0x" + hexTextField.text![0...1])! / 255
        let greenHex = Float("0x" + hexTextField.text![2...3])! / 255
        let blueHex = Float("0x" + hexTextField.text![4...5])! / 255
        
        // TODO: more brightness fractions
        UIView.animate(withDuration: 2.0, animations: {
            self.redControl.setValue(redHex, animated: true)
            self.greenControl.setValue(greenHex, animated: true)
            self.blueControl.setValue(blueHex, animated: true)
            self.brightnessSlider.setValue(1.0, animated: true)
            self.view.backgroundColor = UIColor(red: CGFloat(self.redControl.value), green: CGFloat(self.greenControl.value), blue: CGFloat(self.blueControl.value), alpha: 1)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromBrightnessNotifications()
    }
    
    
    // MARK: Sliders
    
    @IBAction func changeColorComponent(_ sender: AnyObject) {
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
        let hexCode = redHex + greenHex + blueHex

        hexTextField.text = hexCode
        print("setting: \(hexCode)")
        UserDefaults.standard.set(hexCode, forKey: "color")
    }
    
    
    @objc func updateBrightness(_ notification:Notification) {
        brightnessSlider.value = Float(UIScreen.main.brightness)
    }
    
    
    @IBAction func brightnessChanged() {
        UIScreen.main.brightness = CGFloat(brightnessSlider.value)
    }
    
    
    @objc func animateBrightness() {
        if (UIScreen.main.brightness >= 1.0) {
            timer.invalidate()
        }
        else {
            UIScreen.main.brightness += brightnessFractionToAdd
        }
    }
    
    
    // MARK: Keyboard
    
    @IBAction func CharPressed(_ sender: KeyboardButton) {
        guard (hexTextField.text?.count)! < 6 else {
            return
        }
        
        let toAdd = sender.titleLabel?.text
        hexTextField.text?.append(toAdd!)
        
        if hexTextField.text?.count == 6, let newText = hexTextField.text {
            let redHex = Float("0x" + String(newText)[0...1])! / 255
            let greenHex = Float("0x" + String(newText)[2...3])! / 255
            let blueHex = Float("0x" + String(newText)[4...5])! / 255
            
            UIView.animate(withDuration: 0.5, animations: {
                self.redControl.setValue(redHex, animated: true)
                self.greenControl.setValue(greenHex, animated: true)
                self.blueControl.setValue(blueHex, animated: true)
            })
            
            view.backgroundColor = UIColor(red: CGFloat(redControl.value), green: CGFloat(greenControl.value), blue: CGFloat(blueControl.value), alpha: 1)
        }
    }
    
    
    @IBAction func backSpacePressed(_ sender: Any) {
        hexTextField.text =  String((hexTextField.text?.dropLast())!)
    }
    
    
    @IBAction func menuPressed(_ sender: Any) {
        menuStackView.isHidden = !menuStackView.isHidden
        subView.isHidden = menuStackView.isHidden
        if menuStackView.isHidden {
            SKStoreReviewController.requestReview()
        }
    }
    
    
    // MARK: Menu Options
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        menuStackView.isHidden = true
        subView.isHidden = true
        SKStoreReviewController.requestReview()
    }
    
    
    @IBAction func downloadHexAndColor(_ sender: Any) {
        
        guard let myText = hexTextField.text else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            present(alert, animated: true)
            return
        }
        guard myText.count == 6 else {
            let alert = createAlert(alertReasonParam: alertReason.codeTooShort.rawValue)
            present(alert, animated: true)
            return
        }
        
        let image = generateHexImage()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            present(alert, animated: true)
            return
        }
        let alert = createAlert(alertReasonParam: alertReason.imageSaved.rawValue)
        let goToLibraryButton = UIAlertAction(title: "Open Gallery", style: .default, handler: {
            action in
            UIApplication.shared.open(URL(string:"photos-redirect://")!)
        })
        alert.addAction(goToLibraryButton)
        present(alert, animated: true)
    }
    
    
    @IBAction func copyHexAsText(_ sender: Any) {
        
        guard let myText = hexTextField.text else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            present(alert, animated: true)
            return
        }
        guard myText.count == 6 else {
            let alert = createAlert(alertReasonParam: alertReason.codeTooShort.rawValue)
            present(alert, animated: true)
            return
        }
        let pasteboard = UIPasteboard.general
        pasteboard.string = hexTextField.text
        
        let alert = createAlert(alertReasonParam: alertReason.hexSaved.rawValue)
        present(alert, animated: true)
    }
    
    
    @IBAction func copyHexAndColorAsImage(_ sender: Any) {
        
        guard let myText = hexTextField.text else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            present(alert, animated: true)
            return
        }
        guard myText.count == 6 else {
            let alert = createAlert(alertReasonParam: alertReason.codeTooShort.rawValue)
            present(alert, animated: true)
            return
        }
        
        let image = generateHexImage()
        let pasteboard = UIPasteboard.general
        pasteboard.image = image
        
        let alert = createAlert(alertReasonParam: alertReason.imageCopied.rawValue)
        present(alert, animated: true)
    }
    
    
    @IBAction func shareHexAsText(_ sender: Any) {
        
        guard let myText = hexTextField.text else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            present(alert, animated: true)
            return
        }
        guard myText.count == 6 else {
            let alert = createAlert(alertReasonParam: alertReason.codeTooShort.rawValue)
            present(alert, animated: true)
            return
        }

        let activityController = UIActivityViewController(activityItems: [myText], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown.rawValue)
                self.present(alert, animated: true)
                return
            }
        }
        present(activityController, animated: true)

    }
    
    
    @IBAction func shareHexAndColorAsImage(_ sender: Any) {
        
        guard let myText = hexTextField.text else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            present(alert, animated: true)
            return
        }
        guard myText.count == 6 else {
            let alert = createAlert(alertReasonParam: alertReason.codeTooShort.rawValue)
            present(alert, animated: true)
            return
        }
        
        let image = generateHexImage()
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown.rawValue)
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
            subView.isHidden = true
            menuStackView.isHidden = true
            keyboardStackView.isHidden = true
            hexTextField.borderStyle = .none
    
            UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0.0)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let hexImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            for slider in [redControl, greenControl, blueControl, brightnessSlider] {
                slider?.isHidden = false
            }
            subView.isHidden = false
            menuStackView.isHidden = false
            keyboardStackView.isHidden = false
            hexTextField.borderStyle = .roundedRect
    
            return hexImage
        }
    
    // MARK: Notifications
    
    func subscribeToBrightnessNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateBrightness(_:)), name: .UIScreenBrightnessDidChange, object: nil)
    }
    
    
    func unsubscribeFromBrightnessNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIScreenBrightnessDidChange, object: nil)
    }
    
}

