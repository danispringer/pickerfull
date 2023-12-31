//
//  TutorialViewController.swift
//  PickerFull
//
//  Created by Daniel Springer on 8/28/22.
//  Copyright © 2024 Daniel Springer. All rights reserved.
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

        if CommandLine.arguments.contains("--pickerfullScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }

        guard let path = Bundle.main.path(forResource: "vid2", ofType: "mov") else {
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
