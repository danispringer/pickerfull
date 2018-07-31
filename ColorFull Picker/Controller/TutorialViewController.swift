//
//  TutorialViewController.swift
//  ColorFull Picker
//
//  Created by Dani Springer on 30/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var tutorialLabel: UILabel!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        
        let item1 = "Drag the red, green, and blue sliders left or right."
        let item2 = "Edit the HEX code using the keyboard."
        let item3 = "Save or share using the share button."
        
        let strings = [item1, item2, item3]
        
        //let attributesDictionary = [NSAttributedStringKey.font: tutorialLabel.font]
        let fullAttributedString = NSMutableAttributedString(string: "", attributes: [:])
        
        for string: String in strings {
            let bulletPoint: String = "\u{2022}"
            let formattedString: String = "\(bulletPoint) \(string)\n"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
            
            let paragraphStyle = createParagraphAttribute()
            attributedString.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            
            fullAttributedString.append(attributedString)
        }
        
        tutorialLabel.attributedText = fullAttributedString
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    
    // MARK: Helpers
    
    func createParagraphAttribute() -> NSParagraphStyle {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [NSTextTab.OptionKey : Any])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        
        return paragraphStyle
    }
    

    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
