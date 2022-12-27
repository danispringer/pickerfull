//
//  ImagePreviewViewController.swift
//  PickerFull
//
//  Created by Daniel Springer on 9/22/22.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit
import Photos


class ImagePreviewViewController: UIViewController, UIDragInteractionDelegate {

    // MARK: Outlets

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var shareAsImageButton: UIButton!


    // MARK: Properties

    var actualImage: UIImage!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if CommandLine.arguments.contains("--pickerfullScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }

        myImageView.image = actualImage
        myImageView.isUserInteractionEnabled = true
        customEnableDragging(on: myImageView, dragInteractionDelegate: self)
    }


    // MARK: Helpers

    func dragInteraction(_ interaction: UIDragInteraction,
                         itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        // Cast is required for NSItemProviderWriting support.
        let stringItemProvider = NSItemProvider(object: myImageView.image! as UIImage)
        return [
            UIDragItem(itemProvider: stringItemProvider)
        ]
    }


    func customEnableDragging(on view: UIView,
                              dragInteractionDelegate: UIDragInteractionDelegate) {
        let dragInteraction = UIDragInteraction(delegate: dragInteractionDelegate)
        view.addInteraction(dragInteraction)
    }


    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?,
                         contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            let alert = createAlert(alertReasonParam: AlertReason.permissionDeniedGallery,
                                    okMessage: Const.AppInfo.notNowMessage)
            let goToSettingsButton = UIAlertAction(title: "Open Settings",
                                                   style: .default, handler: { _ in
                if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
                    UIApplication.shared.open(url)
                }
            })
            alert.addAction(goToSettingsButton)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            return
        }
        showImageSavedAlert()
    }


    @IBAction func shareAsImage() {
        let image = actualImage!

        let activityController = UIActivityViewController(activityItems: [image],
                                                          applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = shareAsImageButton
        activityController
            .completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown,
                                             okMessage: Const.AppInfo.okMessage)
                if let presenter = alert.popoverPresentationController {
                    presenter.sourceView = self.shareAsImageButton
                }
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }


                return
            }
        }
        DispatchQueue.main.async {
            self.present(activityController, animated: true)
        }

    }


    @IBAction func copyAsImage() {
        var isiOSAppOnMac = false
        isiOSAppOnMac = ProcessInfo.processInfo.isiOSAppOnMac
        if isiOSAppOnMac {
            shareAsImage()
        } else {
            let image = actualImage!
            UIPasteboard.general.image = image
        }
    }


    @IBAction func downloadAsImage() {
        Task { @MainActor in
            let image = actualImage!
            var isiOSAppOnMac = false
            isiOSAppOnMac = ProcessInfo.processInfo.isiOSAppOnMac
            if isiOSAppOnMac {
                PHPhotoLibrary
                    .requestAuthorization(for: .addOnly) { status in
                        switch status {
                            case .authorized:
                                PHPhotoLibrary.shared().performChanges({
                                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                                }, completionHandler: { done, error in
                                    if done {
                                        DispatchQueue.main.async {
                                            self.showImageSavedAlert()
                                        }
                                    } else {
                                        print(error!.localizedDescription)
                                    }
                                })
                            case .denied, .limited, .notDetermined, .restricted:
                                print("\(status)")
                            @unknown default:
                                fatalError()
                        }
                    }
            } else {
                UIImageWriteToSavedPhotosAlbum(
                    image, self,
                    #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }


    func showImageSavedAlert() {
        let alert = createAlert(alertReasonParam: .imageSaved, okMessage: "OK")
        let openGalleryAction = UIAlertAction(title: "Open Photos", style: .default) { _ in
            self.openGalleryTapped()
        }
        alert.addAction(openGalleryAction)
        present(alert, animated: true)
    }


    func openGalleryTapped() {
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
