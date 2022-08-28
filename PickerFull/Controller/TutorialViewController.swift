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

        myTextView.text = """

        (TIP: view this later by tapping on ❔)

        STEP #1: tap 📷, then take or pick a photo

        STEP #2: tap 🎨

        STEP #3: tap the top-left 🖊️ icon

        STEP #4: drag-and-drop the circle over the wanted color

        And you're done! You can now share your color by tapping on SHARE

        (You can now close the color picker page using the "X", and change or remove the photo by tapping \
        on 📷)
        """

    }


    // MARK: Helpers

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true)
    }

}
