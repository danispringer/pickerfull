//
//  TutorialViewController.swift
//  PickerFull
//
//  Created by dani on 8/28/22.
//  Copyright © 2022 Dani Springer. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var myTextView: UITextView!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let aString1 = NSAttributedString("(TIP: view this later by tapping ")
        let infoIcon = NSTextAttachment(image: UIImage(systemName: "info.circle")!)
        let infoiconString = NSAttributedString(attachment: infoIcon)
        let aString2 = NSAttributedString(")")
        let aString3 = NSAttributedString("\n\nSTEP #1: tap ")
        let cameraIcon = NSTextAttachment(image: UIImage(systemName: "camera")!)
        let cameraIconString = NSAttributedString(attachment: cameraIcon)
        let aString4 = NSAttributedString(", then take or pick a photo")
        let aString5 = NSAttributedString("\n\nSTEP #2: tap ")
        let paintIcon = NSTextAttachment(image: UIImage(systemName: "paintpalette")!)
        let paintIconString = NSAttributedString(attachment: paintIcon)
        let aString6 = NSAttributedString("\n\nSTEP #3: tap ")
        let penIcon = NSTextAttachment(image: UIImage(systemName: "eyedropper")!)
        let penIconString = NSAttributedString(attachment: penIcon)
        let aString7 = NSAttributedString("""
        \n\nSTEP #4: drag-and-drop the circle over the wanted color

        And you're done! You can now share your color by tapping
        """)
        let shareIcon = NSTextAttachment(image: UIImage(systemName: "square.and.arrow.up")!)
        let shareIconString = NSAttributedString(attachment: shareIcon)
        let aString8 = NSAttributedString("""
        \n\n(You can now close the color picker page using the "X", and change or remove the photo \
        by tapping
        """)
        let aString9 = NSAttributedString(")")
        let aSpace = NSAttributedString(" ")

        let fullString = NSMutableAttributedString(string: "")
        for attrString in [aString1, infoiconString, aString2, aString3, cameraIconString,
                           aString4, aString5, paintIconString, aString6, penIconString,
                           aString7, aSpace, shareIconString, aString8, aSpace,
                           cameraIconString, aString9
        ] {
            fullString.append(attrString)
        }

        let myFont: UIFont = UIFont.preferredFont(forTextStyle: .body)

        fullString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.label,
                                  NSAttributedString.Key.font: myFont],
                                 range: (fullString.string as NSString).range(of: fullString.string))

        // draw the result in a label
        myTextView.attributedText = fullString

    }


    // MARK: Helpers

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true)
    }

}
