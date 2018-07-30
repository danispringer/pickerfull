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
    @IBOutlet weak var myTextView: UITextView!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }
    
    
    // MARK: Helpers
    
    @IBAction func backToTopPressed(_ sender: Any) {
        myTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
    

    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
