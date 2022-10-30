//
//  ImagePreviewViewController.swift
//  PickerFull
//
//  Created by dani on 9/22/22.
//  Copyright © 2022 Dani Springer. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var myImageView: UIImageView!


    // MARK: Properties

    var actualImage: UIImage!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        myImageView.image = actualImage
    }


    // MARK: Helpers

    @IBAction func openGalleryTapped(_ sender: Any) {
        var isiOSAppOnMac = false
        isiOSAppOnMac = ProcessInfo.processInfo.isiOSAppOnMac
        if isiOSAppOnMac {
            let path = (FileManager.default.urls(
                for: .applicationDirectory,
                in: .systemDomainMask
            ).first?.appendingPathComponent("Photos.app"))!
            UIApplication.shared.open(path)

        } else {
            UIApplication.shared.open(URL(string: Const.AppInfo.galleryLink)!)
        }

    }


    @IBAction func notNowTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
