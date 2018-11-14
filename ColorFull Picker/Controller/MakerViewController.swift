//
//  MakerViewController.swift
//  Color Picker
//
//  Created by Dani Springer on 06/03/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import StoreKit

class MakerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {
    

    // MARK: Outlets
    
    @IBOutlet weak var redControl: UISlider!
    @IBOutlet weak var greenControl: UISlider!
    @IBOutlet weak var blueControl: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var hexPicker: UIPickerView!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    

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

        menuTableView.isHidden = true
        
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
        
        menuButton.layer.cornerRadius = 10
        menuButton.titleLabel?.textColor = .white
        menuButton.backgroundColor = UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 0.5)
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)

        myTableView.backgroundColor = .black
        myTableView.tintColor = .white
        
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
        menuTableView.isHidden.toggle()
        
        if menuTableView.isHidden {
            SKStoreReviewController.requestReview()
            menuButton.setImage(UIImage(named: "menu.png"), for: .normal)
        } else {
            menuButton.setImage(UIImage(named: "close.png"), for: .normal)
            let myIndexPath = IndexPath(row: 0, section: 0)
            menuTableView.scrollToRow(at: myIndexPath, at: .top, animated: true)
            menuTableView.flashScrollIndicators()
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
            menuTableView.isHidden = true
            hexPicker.isHidden = true
            menuButton.isHidden = true
            
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
            menuTableView.isHidden = false
            hexPicker.isHidden = false
            menuButton.isHidden = false
    
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
    
    
    // MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text = "\(myDataSource[(indexPath as NSIndexPath).row])"
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
        cell.tintColor = .white
        cell.textLabel?.backgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
        cell.textLabel?.tintColor = .white
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            downloadHexAndColor()
        case 1:
            copyHexAsText()
        case 2:
            copyHexAndColorAsImage()
        case 3:
            shareHexAsText()
        case 4:
            shareHexAndColorAsImage()
        case 5:
            pasteText()
        case 6:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AboutViewController")
            present(controller, animated: true)
        default:
            print("default")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Menu"
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .black
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
    
    
    // MARK: Notifications
    
    func subscribeToBrightnessNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateBrightness(_:)), name: UIScreen.brightnessDidChangeNotification, object: nil)
    }
    
    
    func unsubscribeFromBrightnessNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIScreen.brightnessDidChangeNotification, object: nil)
    }
    
}

