//
//  MagicTableViewController.swift
//  ColorFull
//
//  Created by dani on 1/31/22.
//  Copyright © 2022 Dani Springer. All rights reserved.
//

import UIKit

class MagicTableViewController: UITableViewController {

    // MARK: Properties

    var myDataSource: [String] = []


    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if UD.dictionary(forKey: Const.UserDef.magicDict) == nil {
            let emptyDict: [String: String] = [:]
            UD.register(defaults: [Const.UserDef.magicDict: emptyDict])
        }

        let savedColors = UD.dictionary(forKey: Const.UserDef.magicDict) as! [String: String]

        let sortedDict = savedColors.sorted { Double($0.key)! > Double($1.key)! }
        for pair in sortedDict {
            myDataSource.append(pair.value)
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.StoryboardIDIB.magicCell) as! MagicCell

        cell.hexLabel.text = "HEX: \(myDataSource[indexPath.row])"
        cell.rgbLabel.text = "RGB: \(rgbFrom(hex: myDataSource[indexPath.row]) ?? "error")"
        cell.colorView.backgroundColor = uiColorFrom(hex: myDataSource[indexPath.row])
        cell.colorView.layer.cornerRadius = 4

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
        Magic History - Tap on a color to restore it (so you can edit and/or save it).
        """
    }


    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return """
        This page displays your 10 most recent magically created colors (meaning colors created using the leftmost \
        button on the homepage of the app), in case, due to an accidental tap, you lose one before saving it as an \
        image.
        """
    }

}
