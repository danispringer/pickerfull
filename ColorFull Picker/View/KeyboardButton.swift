//
//  KeyboardButton.swift
//  ColorFull Picker
//
//  Created by Dani Springer on 15/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit

class KeyboardButton: UIButton {
    
    // MARK: Properties

    let cornerRadius: CGFloat = 5.0
    
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        themeBorderedButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        themeBorderedButton()
    }
    
    func themeBorderedButton() {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
}
