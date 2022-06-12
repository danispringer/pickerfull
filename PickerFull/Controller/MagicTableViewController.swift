//
//  MagicTableViewController.swift
//  PickerFull
//
//  Created by Daniel Springer on 1/31/22.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit

class MagicTableViewController: UITableViewController {


    // MARK: Properties
//
//    var editButton: UIBarButtonItem!

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if CommandLine.arguments.contains("--pickerfullScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }

        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    // MARK: Helpers

    func getDict() -> [String: String] {
        return UD.dictionary(forKey: Const.UserDef.magicDict) as! [String: String]
    }


    func getSortedKeys() -> [Double] {
        let myDict: [String: String] = UD.dictionary(forKey: Const.UserDef.magicDict) as! [String: String]
        let allKeysAsStrings = Array(myDict.keys)
        let allKeysAsDoubles: [Double] = allKeysAsStrings.map { Double($0)!}
        let sortedKeys = allKeysAsDoubles.sorted { $0 > $1 }
        return sortedKeys
    }


    // MARK: TableView

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let presenter = presentingViewController as? MakerViewController {
            let sortedKeys = getSortedKeys()
            let theKey: String = "\(sortedKeys[indexPath.row])"
            let theHexValue: String = getDict()[theKey]!
            presenter.updateColor(hexStringParam: theHexValue)
        }
        dismiss(animated: true)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.StoryboardIDIB.magicCell) as! MagicCell
        let sortedKeys = getSortedKeys()
        cell.hexLabel.text = "HEX: \(getDict()["\(sortedKeys[indexPath.row])"]!)"
        cell.rgbLabel.text = "RGB: \(rgbFrom(hex: getDict()["\(sortedKeys[indexPath.row])"]!))"
        cell.colorView.backgroundColor = uiColorFrom(hex: getDict()["\(sortedKeys[indexPath.row])"]!)
        cell.colorView.layer.cornerRadius = 6
        return cell
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSortedKeys().count
    }


    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return """
        Forgot to save a "Random" color?
        Here are the 10 most recent ones.
        Tap one to restore it.
        """
    }


    //    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    //        return """
    //        text goes here...
    //        """
    //    }


    override func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let copyAction = UIContextualAction(
                style: .normal, title: "Copy HEX",
                handler: { (_, _, success: (Bool) -> Void) in
                    let hexToCopy: String = (tableView.cellForRow(at: indexPath) as! MagicCell).hexLabel.text!
                    UIPasteboard.general.string = String(hexToCopy.suffix(6))
                    print("copied")
                    success(true)
                })
            copyAction.backgroundColor = .blue

            return UISwipeActionsConfiguration(actions: [copyAction])
        }


    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(
                style: .destructive, title: "Eliminationnnn",
                handler: { (_, _, success: (Bool) -> Void) in
                    print("happened")
                    let sortedKeys = self.getSortedKeys()
                    let hexKeyItem: String = "\(sortedKeys[indexPath.row])"
                    var myDict = self.getDict()
                    myDict[hexKeyItem] = nil
                    UD.set(myDict, forKey: Const.UserDef.magicDict)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                    success(true)
                })
            deleteAction.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }

//    override func tableView(_ tableView: UITableView,
//    shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    override func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
//        // Replace the Edit button with Done, and put the
//        // table view into editing mode.
//        self.setEditing(true, animated: true)
//    }

}
