//
//  MakerViewController.swift
//  Color Picker
//
//  Created by Dani Springer on 06/03/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import StoreKit

class MakerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Outlets
    
    @IBOutlet weak var redControl: UISlider!
    @IBOutlet weak var greenControl: UISlider!
    @IBOutlet weak var blueControl: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var menuStackView: UIStackView!
    @IBOutlet weak var hexPicker: UIPickerView!
    

    // MARK: properties
    
    var currentUIColor: UIColor!
    var currentHexColor: String!
    var timer: Timer!
    var brightnessFractionToAdd: CGFloat!
    
    var rawArray = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "0A", "0B", "0C", "0D", "0E", "0F", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "1A", "1B", "1C", "1D", "1E", "1F", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "2A", "2B", "2C", "2D", "2E", "2F", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "3A", "3B", "3C", "3D", "3E", "3F", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "4A", "4B", "4C", "4D", "4E", "4F", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "5A", "5B", "5C", "5D", "5E", "5F", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "6A", "6B", "6C", "6D", "6E", "6F", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "7A", "7B", "7C", "7D", "7E", "7F", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "8A", "8B", "8C", "8D", "8E", "8F", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "9A", "9B", "9C", "9D", "9E", "9F", "A0", "A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "AA", "AB", "AC", "AD", "AE", "AF", "B0", "B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "BA", "BB", "BC", "BD", "BE", "BF", "C0", "C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "CA", "CB", "CC", "CD", "CE", "CF", "D0", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "DA", "DB", "DC", "DD", "DE", "DF", "E0", "E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", "EA", "EB", "EC", "ED", "EE", "EF", "F0", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "FA", "FB", "FC", "FD", "FE", "FF"] // TODO: generate
    
    var redArray: [String]!
    var greenArray: [String]!
    var blueArray: [String]!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hexPicker.delegate = self
        
        redArray = rawArray
        greenArray = rawArray
        blueArray = rawArray

        menuStackView.isHidden = true
        subView.isHidden = true
        subView.layer.borderColor = UIColor.white.cgColor
        subView.layer.borderWidth = 5
        subView.layer.cornerRadius = 10
        subView.layer.shadowOffset = CGSize(width: -20, height: 15)
        subView.layer.shadowRadius = 10
        subView.layer.shadowOpacity = 0.6
        
        let initialBrightness = UIScreen.main.brightness
        let brightnessMissing = 1.0 - initialBrightness
        brightnessFractionToAdd = brightnessMissing / 200.0
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.animateBrightness), userInfo: nil, repeats: true)
        
        redControl.thumbTintColor = .red
        greenControl.thumbTintColor = .green
        blueControl.thumbTintColor = .blue

        redControl.minimumTrackTintColor = UIColor.red
        greenControl.minimumTrackTintColor = UIColor.green
        blueControl.minimumTrackTintColor = UIColor.blue
        
        if UserDefaults.standard.string(forKey: "color") == nil {
            UserDefaults.standard.register(defaults: ["color": "E57BF2"])
        }
        
        // hexString = UserDefaults.standard.string(forKey: "color")
        
        // red = Float("0x" + hexTextField.text![0...1])! / 255
        // green = Float("0x" + hexTextField.text![2...3])! / 255
        // blue = Float("0x" + hexTextField.text![4...5])! / 255
        
        UIView.animate(withDuration: 2.0, animations: {
            //self.redControl.setValue(RED, animated: true)
            //self.greenControl.setValue(GREEN, animated: true)
            //self.blueControl.setValue(BLUE, animated: true)
            self.brightnessSlider.setValue(1.0, animated: true)
            self.view.backgroundColor = UIColor(red: CGFloat(self.redControl.value), green: CGFloat(self.greenControl.value), blue: CGFloat(self.blueControl.value), alpha: 1)
        })
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subscribeToBrightnessNotifications()
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

        // hexString = hexCode
        
        // UserDefaults.standard.set(HEXSTRING, forKey: "color")
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
            return rawArray.count // TODO: use specific arrays?
        } else {
            fatalError()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let arrays = [redArray, greenArray, blueArray] // TODO: needed? Maybe replace with rawArray
        var currentArray = [""]
        if component == 0 || component == 1 || component == 2 {
            currentArray = arrays[component]!
        } else {
            print("component is: \(component)")
        }
        return currentArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            // TODO: update hexString, sliders, view, user defaults
        } else {
            fatalError()
        }
        
        
    }

    
    // MARK: Menu Options
    
    @IBAction func menuPressed(_ sender: Any) {
        menuStackView.isHidden = !menuStackView.isHidden
        subView.isHidden = menuStackView.isHidden
        if menuStackView.isHidden {
            SKStoreReviewController.requestReview()
        }
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        menuStackView.isHidden = true
        subView.isHidden = true
        SKStoreReviewController.requestReview()
    }
    
    
    @IBAction func downloadHexAndColor(_ sender: Any) {
        
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

        let pasteboard = UIPasteboard.general
        pasteboard.string = "" // TODO: hexString
        
        let alert = createAlert(alertReasonParam: alertReason.hexSaved.rawValue)
        present(alert, animated: true)
    }
    
    
    @IBAction func copyHexAndColorAsImage(_ sender: Any) {
        
        let image = generateHexImage()
        let pasteboard = UIPasteboard.general
        pasteboard.image = image
        
        let alert = createAlert(alertReasonParam: alertReason.imageCopied.rawValue)
        present(alert, animated: true)
    }
    
    
    @IBAction func shareHexAsText(_ sender: Any) {
        
        let myText = "" // TODO

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
            UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0.0)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let hexImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            for slider in [redControl, greenControl, blueControl, brightnessSlider] {
                slider?.isHidden = false
            }
            subView.isHidden = false
            menuStackView.isHidden = false
    
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

