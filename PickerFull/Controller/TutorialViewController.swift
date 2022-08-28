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
        hello, this is tutorial. this paragraph will say how to use this app, as well as remind users \
        that they can see this tutorial again later... This text is scrollable, simply by swiping on it, \
        so it can be very long, and the design won't break. It can also have emojis 🤩 bold text, and lots \
        more.
        """

    }


    // MARK: Helpers

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true)
    }

}
