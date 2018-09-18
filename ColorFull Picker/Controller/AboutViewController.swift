//
//  AboutViewController.swift
//  ColorFull Picker
//
//  Created by Dani Springer on 30/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        if let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] {
            versionLabel.text = "Version \(version)"
        } else {
            versionLabel.text = "Error displaying version. Please let the developer know."
        }
    }
    
    // MARK: Dismiss
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Share
    
    @IBAction func shareButtonPressed() {
        let message = "Look at this app: ColorFull Picker lets you generate a color from millions of choices using sliders or HEX code, and save or share your color and code! https://itunes.apple.com/app/id1410565176 - it's really cool!"
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown)
                self.present(alert, animated: true)
                return
            }
        }
        present(activityController, animated: true)
    }
}

extension AboutViewController: MFMailComposeViewControllerDelegate {
    
    @IBAction func launchEmail(sender: AnyObject) {
        
        var emailTitle = "ColorFull Picker"
        if let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] {
            emailTitle += " \(version)"
        }
        
        let messageBody = "Hi. I have a question..."
        let toRecipents = ["***REMOVED***"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var alert = UIAlertController()
        
        dismiss(animated: true, completion: {
            switch result {
            case MFMailComposeResult.failed:
                alert = self.createAlert(alertReasonParam: alertReason.messageFailed)
            case MFMailComposeResult.saved:
                alert = self.createAlert(alertReasonParam: alertReason.messageSaved)
            case MFMailComposeResult.sent:
                alert = self.createAlert(alertReasonParam: alertReason.messageSent)
            default:
                break
            }
            if let _ = alert.title {
                self.present(alert, animated: true)
            }
        })
    }
}

extension AboutViewController {
    
    @IBAction func requestReviewManually() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL
        
        guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id1410565176?action=write-review")
            else {
                fatalError("Expected a valid URL")
        }
        
        UIApplication.shared.open(writeReviewURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        
        
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
