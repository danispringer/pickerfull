//
//  TutorialViewController.swift
//  PickerFull
//
//  Created by dani on 8/28/22.
//  Copyright © 2022 Dani Springer. All rights reserved.
//

import UIKit
import AVKit

class TutorialViewController: UIViewController, AVPlayerViewControllerDelegate {

    // MARK: Outlets

    @IBOutlet weak var myTextView: UITextView!


    // MARK: Properties

    let playerController = AVPlayerViewController()
    var player: AVPlayer!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tutorial"

        let aString1 = NSAttributedString("(Tap ")
        let aString1b = NSAttributedString(" to view this tutorial later)\n")
        let infoIcon = NSTextAttachment(image: UIImage(systemName: "info.circle")!)
        let infoiconString = NSAttributedString(attachment: infoIcon)
        let aString3 = NSAttributedString("\n\nTap ")
        let cameraIcon = NSTextAttachment(image: UIImage(systemName: "camera")!)
        let cameraIconString = NSAttributedString(attachment: cameraIcon)
        let aString4 = NSAttributedString(" to take or pick a photo")
        let aString5 = NSAttributedString("\n\nTap ")
        let aString5b = NSAttributedString(", then tap ")
        let aString5c = NSAttributedString(" , to bring up ")
        let circleIcon = NSTextAttachment(image: UIImage(systemName: "square.circle")!)
        let circleIconString = NSAttributedString(attachment: circleIcon)
        let paintIcon = NSTextAttachment(image: UIImage(systemName: "paintpalette")!)
        let paintIconString = NSAttributedString(attachment: paintIcon)
        let penIcon = NSTextAttachment(image: UIImage(systemName: "eyedropper")!)
        let penIconString = NSAttributedString(attachment: penIcon)
        let aString7 = NSAttributedString("\n\nDrag ")
        let aString7b = NSAttributedString("""
         over the wanted color, then let it go to select that color
        """)
        let aString8 = NSAttributedString("""
        \n\nThat's it! Share your color by tapping
        """)
        let shareIcon = NSTextAttachment(image: UIImage(systemName: "square.and.arrow.up")!)
        let shareIconString = NSAttributedString(attachment: shareIcon)
        let aSpace = NSAttributedString(" ")

        let fullString = NSMutableAttributedString(string: "")
        for attrString in [aString1, infoiconString, aString1b, aString3, cameraIconString,
                           aString4, aString5, paintIconString, aString5b, penIconString,
                           aString5c, circleIconString, aString7, circleIconString, aString7b,
                           aString8, aSpace, shareIconString
        ] {
            fullString.append(attrString)
        }

        let myFont: UIFont = UIFont.preferredFont(forTextStyle: .body)

        fullString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.label,
                                  NSAttributedString.Key.font: myFont],
                                 range: (fullString.string as NSString).range(of: fullString.string))

        // draw the result in a label
        myTextView.attributedText = fullString

        guard let path = Bundle.main.path(forResource: "vid", ofType: "mov") else {
            debugPrint("vid.mov not found")
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))

        NotificationCenter.default.addObserver(
            self, selector: #selector(didfinishPlaying),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)

    }


    // MARK: Helpers

    func playerViewController(
        _ playerViewController: AVPlayerViewController,
        restoreUserInterfaceForPictureInPictureStopWithCompletionHandler
        completionHandler: @escaping (Bool) -> Void) {
            present(playerController, animated: true) { [self] in
                player.play()
                completionHandler(true)
            }
        }


    @objc func didfinishPlaying() {
        playerController.dismiss(animated: true, completion: nil)
    }


    @IBAction func playVideoTapped(_ sender: Any) {
        playerController.player = player
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(true, options: [])
        playerController.delegate = self
        present(playerController, animated: true) { [self] in
            player.play()
        }

    }


}
