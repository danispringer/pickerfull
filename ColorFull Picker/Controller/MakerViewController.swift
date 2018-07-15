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
    

    // MARK: placeholders
    
    var currentUIColor: UIColor!
    var currentHexColor: String!
    
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //        infoTextView.text = "What can you do?\n\u{2022} Drag the sliders to get a colour you like, and copy the generated HEX code to save your lovely blend.\n\u{2022} Edit the code to preview any colour from millions of choices." // TODO: move to tutorial view
        
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
        //        userTextField.text = hexCode // TODO: assign to eventual label
    }
}

