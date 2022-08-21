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
        self.title = "Random History"
    }


    // MARK: Helpers

    func getArray() -> [String]? {
        return readFromDocs(fromDocumentsWithFileName: Const.UserDef.filename)
    }


    // MARK: TableView

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rootViewController = self.navigationController!.viewControllers.first as! MakerViewController
        let theHexValue: String = getArray()?[indexPath.row] ?? "oops1"
        rootViewController.updateColor(hexStringParam: theHexValue)

        self.navigationController!.popToRootViewController(animated: true)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.StoryboardIDIB.magicCell) as! MagicCell
        cell.hexLabel.text = "HEX: \(getArray()![indexPath.row])"
        cell.rgbLabel.text = "RGB: \(rgbFrom(hex: getArray()![indexPath.row]))"
        cell.colorView.backgroundColor = uiColorFrom(hex: getArray()![indexPath.row])
        cell.colorView.layer.cornerRadius = 6
        return cell
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getArray()?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return """
        Forgot to save a "Random" color?
        Here are the 10 most recent ones.
        Tap one to restore it.

        Swipe one to delete it.

        Long press one for more options.
        """
    }


    //    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    //        return """
    //        text goes here...
    //        """
    //    }


//    override func tableView(
//        _ tableView: UITableView,
//        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//            let copyAction = UIContextualAction(
//                style: .normal, title: "Copy HEX",
//                handler: { (_, _, success: (Bool) -> Void) in
//                    let hexToCopy: String = (tableView.cellForRow(at: indexPath) as! MagicCell).hexLabel.text!
//                    UIPasteboard.general.string = String(hexToCopy.suffix(6))
//                    print("copied")
//                    success(true)
//                })
//            copyAction.backgroundColor = .blue
//
//            return UISwipeActionsConfiguration(actions: [copyAction])
//        }


    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(
                style: .destructive, title: "Delete",
                handler: { [self] (_, _, success: (Bool) -> Void) in
                    print("happened")
                    let hexKeyItem: String = getArray()![indexPath.row]
                    var currentArray: [String] = readFromDocs(fromDocumentsWithFileName: Const.UserDef.filename) ?? []
                    currentArray = currentArray.filter { $0 != hexKeyItem }
                    saveToDocs(text: currentArray.joined(separator: ","), withFileName: Const.UserDef.filename)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                    success(true)
                })
            deleteAction.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }


    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {
//        let item = getSortedKeys()[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let copyHEXAction = UIAction(title: "Copy HEX", image: UIImage(systemName: "doc.on.doc")) { _ in
                let hexToCopy: String = (tableView.cellForRow(at: indexPath) as! MagicCell).hexLabel.text!
                UIPasteboard.general.string = String(hexToCopy.suffix(6))
            }

            let copyRGBAction = UIAction(title: "Copy RGB", image: UIImage(systemName: "doc.on.doc")) { _ in
                let rgbToCopy: String = (tableView.cellForRow(at: indexPath) as! MagicCell).rgbLabel.text!
                UIPasteboard.general.string = String(rgbToCopy[5...rgbToCopy.count-1])
            }

            return UIMenu(title: "", children: [copyHEXAction, copyRGBAction])
        }
    }

}
