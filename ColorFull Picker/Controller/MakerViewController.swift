//
//  MakerViewController.swift
//  Color Picker
//
//  Created by Dani Springer on 06/03/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit

class MakerViewController: UIViewController, UITextFieldDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var redControl: UISlider!
    @IBOutlet weak var greenControl: UISlider!
    @IBOutlet weak var blueControl: UISlider!
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel! // TODO: to remove after customising keyboard
    @IBOutlet weak var infoTextView: UITextView! // TODO: to remove after creating tutorial page
    
    
    // MARK: placeholders
    
    var currentUIColor: UIColor!
    var currentHexColor: String!
    
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.changeColorComponent(self)
        redControl.minimumTrackTintColor = UIColor.red
        greenControl.minimumTrackTintColor = UIColor.green
        blueControl.minimumTrackTintColor = UIColor.blue
        
        userTextField.text = "E57BF2"
        // update controls with animation
        let redHex = Float("0xE5")! / 255
        let greenHex = Float("0x7B")! / 255
        let blueHex = Float("0xF2")! / 255
        UIView.animate(withDuration: 1.0, animations: {
            self.redControl.setValue(redHex, animated: true)
            self.greenControl.setValue(greenHex, animated: true)
            self.blueControl.setValue(blueHex, animated: true)
            
            self.view.backgroundColor = UIColor(red: CGFloat(self.redControl.value), green: CGFloat(self.greenControl.value), blue: CGFloat(self.blueControl.value), alpha: 1)
        })
        
        
        
        
        
        warningLabel.isHidden = true
        infoTextView.text = "What can you do?\n\u{2022} Drag the sliders to get a colour you like, and copy the generated HEX code to save your lovely blend.\n\u{2022} Edit the code to preview any colour from millions of choices."
        infoTextView.contentInset.top = 5
        infoTextView.contentInset.right = 5
        infoTextView.contentInset.bottom = 5
        infoTextView.contentInset.left = 5
        infoTextView.isEditable = false
        infoTextView.isUserInteractionEnabled = false
        infoTextView.tintColor = UIColor.black
        infoTextView.backgroundColor = UIColor(white: 1, alpha: 0.6)
        
        self.userTextField.delegate = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: Helpers
    
    @IBAction func changeColorComponent(_ sender: AnyObject) {
        let r: CGFloat = CGFloat(self.redControl.value)
        let g: CGFloat = CGFloat(self.greenControl.value)
        let b: CGFloat = CGFloat(self.blueControl.value)
        
        view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        
        
        redControl.setThumbImage(SliderIcon.red , for: .normal)
        redControl.setThumbImage(SliderIcon.red, for: .highlighted)
        
        greenControl.setThumbImage(SliderIcon.green, for: .normal)
        greenControl.setThumbImage(SliderIcon.green, for: .highlighted)

        blueControl.setThumbImage(SliderIcon.blue, for: .normal)
        blueControl.setThumbImage(SliderIcon.blue, for: .highlighted)
        
        let rBase255 = Int(r * 255)
        let gBase255 = Int(g * 255)
        let bBase255 = Int(b * 255)
        let redHex = String(format: "%02X", rBase255)
        let greenHex = String(format: "%02X", gBase255)
        let blueHex = String(format: "%02X", bBase255)
        let hexCode = redHex + greenHex + blueHex
        userTextField.text = hexCode
    }
    
    
    func showWarning(reason: String) {
        if reason == "invalidChar" {
            warningLabel.text = "Please use:\nA-F, 0-9"
        } else if reason == "maxChars" {
            warningLabel.text = "Max 6\n characters\nallowed"
        }
        warningLabel.isHidden = false
        warningLabel.alpha = 1.0
        UIView.animate(withDuration: 3.0, animations: {
            self.warningLabel.alpha = 0.0
        }, completion: {(finished: Bool) in
            if finished {
                self.warningLabel.isHidden = true
                self.warningLabel.alpha = 1.0
            }
        })
        
    }
    
    
    // MARK: delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var oldText = textField.text!
        oldText = oldText.uppercased()
        let hexCharSet = CharacterSet(charactersIn: "1234567890ABCDEF")
        
        let filtered = string.components(separatedBy: hexCharSet).joined(separator: "")
        
        for c in string.unicodeScalars {
            if !hexCharSet.contains(UnicodeScalar(c)) {
                showWarning(reason: "invalidChar")
                return false
            }
        }
        
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        if newText.length > 6 {
            showWarning(reason: "maxChars")
            return false
        }
        
        if string.count == 0 {
            // Backspace key pressed
            return true
        }
        
        if newText.length == 6 {
            let redHex = Float("0x" + String(newText)[0...1])! / 255
            let greenHex = Float("0x" + String(newText)[2...3])! / 255
            let blueHex = Float("0x" + String(newText)[4...5])! / 255
            UIView.animate(withDuration: 0.5, animations: {
                self.redControl.setValue(redHex, animated: true)
                self.greenControl.setValue(greenHex, animated: true)
                self.blueControl.setValue(blueHex, animated: true)
            })
            
            
            view.backgroundColor = UIColor(red: CGFloat(redControl.value), green: CGFloat(greenControl.value), blue: CGFloat(blueControl.value), alpha: 1)
            return true
        }
        
        if newText.length > 5 {
            showWarning(reason: "maxChars")
            return false
        }
        
        return !(string == filtered)
    }
    
    
    // MARK: Subscription
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    // MARK: Keyboard
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
}

