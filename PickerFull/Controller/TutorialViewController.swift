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

    @IBOutlet weak var iconExtraImageView: UIImageView!

    // MARK: Properties

    let playerController = AVPlayerViewController()
    var player: AVPlayer!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //        let aString1 = NSAttributedString("To watch later: tap ")
        //        let infoIcon = NSTextAttachment(image: UIImage(systemName: "info.circle")!)
        //        let infoiconString = NSAttributedString(attachment: infoIcon)
        //        let aString2 = NSAttributedString(" on home screen, then tap \"Watch Tutorial\"")
        //
        //        let fullString = NSMutableAttributedString(string: "")
        //        for attrString in [aString1, infoiconString, aString2] {
        //            fullString.append(attrString)
        //        }
        //
        //        let myFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
        //
        //        fullString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.label,
        //                                  NSAttributedString.Key.font: myFont],
        //                                 range: (fullString.string as NSString).range(of: fullString.string))

        //        myTextView.attributedText = fullString
        //        myTextView.layer.cornerRadius = 8
        //        myTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        guard let path = Bundle.main.path(forResource: "vid", ofType: "mov") else {
            debugPrint("vid.mov not found")
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))

        NotificationCenter.default.addObserver(
            self, selector: #selector(didfinishPlaying),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)

        iconExtraImageView.layer.cornerRadius = 16

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
        guard !(player.timeControlStatus == .playing) else {
            present(playerController, animated: true)
            return
        }

        playerController.player = player
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(true, options: [])
        playerController.delegate = self

        present(playerController, animated: true) { [self] in
            player.play()
        }

    }


    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true)
    }


}
