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

    var myDataSource: [String] = []


    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if CommandLine.arguments.contains("--pickerfullScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }

        let savedColors = UD.dictionary(forKey: Const.UserDef.magicDict) as! [String: String]
        let sortedDict = savedColors.sorted { Double($0.key)! > Double($1.key)! }
        for pair in sortedDict {
            myDataSource.append(pair.value)
        }
    }


    // MARK: TableView

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let presenter = presentingViewController as? MakerViewController {
            presenter.updateColor(hexStringParam: myDataSource[indexPath.row])
        }
        dismiss(animated: true)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.StoryboardIDIB.magicCell) as! MagicCell
        cell.hexLabel.text = "HEX: \(myDataSource[indexPath.row])"
        cell.rgbLabel.text = "RGB: \(rgbFrom(hex: myDataSource[indexPath.row]))"
        cell.colorView.backgroundColor = uiColorFrom(hex: myDataSource[indexPath.row])
        cell.colorView.layer.cornerRadius = 6
        return cell
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataSource.count
    }


    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return """
        Forgot to save a "Random" color?
        Here are the 10 most recents.
        Tap one to restore it.
        """
    }


//    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return """
//        Forgot to save a "Random" color?
//        Here are the 10 most recents.
//        Tap one to restore it.
//        """
//    }

}
