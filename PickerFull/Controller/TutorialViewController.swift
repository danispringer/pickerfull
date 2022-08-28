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

        (TIP: you can view this page later by tapping "About App")

        STEP #1: tap "Choose Photo" and take or pick a photo
        STEP #2: (Optional) Once a photo is added to the app pinch to zoom in to the wanted color
        STEP #3: tap "Image Color Picker"
        STEP #4: tap the top-left pen icon
        STEP #5: drag-and-drop the circle over the wanted color
        """

    }


    // MARK: Helpers

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true)
    }

}
