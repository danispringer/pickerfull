//
//  MakerViewController.swift
//  Color Picker
//
//  Created by Dani Springer on 06/03/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit

class MakerViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var redControl: UISlider!
    @IBOutlet weak var greenControl: UISlider!
    @IBOutlet weak var blueControl: UISlider!
    @IBOutlet weak var hexTextField: UITextField!
    

    // MARK: placeholders
    
    var currentUIColor: UIColor!
    var currentHexColor: String!
    
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hexTextField.isEnabled = false
        
        self.changeColorComponent(self)
        redControl.minimumTrackTintColor = UIColor.red
        greenControl.minimumTrackTintColor = UIColor.green
        blueControl.minimumTrackTintColor = UIColor.blue
        
        //        userTextField.text = "E57BF2" // TODO: add text to eventual label
        
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
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

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

        hexTextField.text = hexCode
    }
    
    
    @IBAction func CharPressed(_ sender: KeyboardButton) {
        guard (hexTextField.text?.count)! < 6 else {
            
            print(alertReason.maxChars.rawValue)
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
    
    
//    func generateMemedImage() -> UIImage {
//        let fontPickerWasHidden = fontPicker.isHidden
//        let colorPickerWasHidden = colorPicker.isHidden
//
//        for toolbar in [topToolbar, bottomToolbar] {
//            toolbar?.isHidden = true
//        }
//
//        for picker in [fontPicker, colorPicker] {
//            picker?.isHidden = true
//        }
//
//        for button in [fontPickerDoneButton, colorPickerDoneButton] {
//            button?.isHidden = true
//        }
//
//        for field in [topTextField, bottomTextField] {
//            field?.isEnabled = false
//            field?.borderStyle = .none
//        }
//
//        view.frame.origin.y = 0
//
//        UIGraphicsBeginImageContext(self.view.frame.size)
//        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
//        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//
//        for toolbar in [topToolbar, bottomToolbar] {
//            toolbar?.isHidden = false
//        }
//
//        if !fontPickerWasHidden {
//            fontPicker.isHidden = false
//            fontPickerDoneButton.isHidden = false
//        }
//        if !colorPickerWasHidden {
//            colorPicker.isHidden = false
//            colorPickerDoneButton.isHidden = false
//        }
//
//        for field in [topTextField, bottomTextField] {
//            field?.isEnabled = true
//            field?.borderStyle = .line
//        }
//
//        return memedImage
//    }
    
    
    @IBAction func backSpacePressed(_ sender: Any) {
        hexTextField.text =  String((hexTextField.text?.dropLast())!)
    }
    
    
    @IBAction func hideKeyboardPressed(_ sender: Any) {
    
    }
    
    
}

