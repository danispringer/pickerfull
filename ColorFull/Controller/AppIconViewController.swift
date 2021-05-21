//
//  AppIconViewController.swift
//  ColorFull
//
//  Created by Daniel Springer on 5/27/19.
//  Copyright © 2020 Dani Springer. All rights reserved.
//

import UIKit
import StoreKit


class AppIconViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    // MARK: Outlets

    @IBOutlet weak var myTableView: UITableView!


    // MARK: Properties

    var textColor: UIColor! = nil
    var backgroundColor: UIColor! = nil
    let myDataSource = ["0", "1"]
    let colorNames = ["Purple on White", "White on Purple"]


    // MARK: Life Cycle


    // MARK: Helpers


    func updateIcon() {
        let newIconNumberValue = UserDefaults.standard.integer(forKey: Const.UserDef.selectedIcon)

        guard UIApplication.shared.supportsAlternateIcons else {
            return
        }

        UIApplication.shared.setAlternateIconName("\(newIconNumberValue)") { error in
            if let error = error {
                print("App icon failed to change name to \(newIconNumberValue) due to \(error.localizedDescription)")
            } else {
                print("app icon should now be updated")
            }
        }
    }


    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    // MARK: TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataSource.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Const.CellID.appIconCell) as? AppIconCell
        cell?.selectionStyle = .none
        cell?.myImageView?.image = UIImage(named: "\(indexPath.row)")
        cell?.myLabel.text = colorNames[indexPath.row]
        cell?.accessoryType = .none

        let myIndexPath = IndexPath(
            row: UserDefaults.standard.integer(forKey: Const.UserDef.selectedIcon),
            section: 0)
        if indexPath == myIndexPath {
            cell?.accessoryType = .checkmark
        }

        return cell ?? UITableViewCell()
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oldRow = UserDefaults.standard.integer(forKey: Const.UserDef.selectedIcon)
        UserDefaults.standard.set(indexPath.row, forKey: Const.UserDef.selectedIcon)
        print("Constants...selectedIcon): \(UserDefaults.standard.integer(forKey: Const.UserDef.selectedIcon))")
        updateIcon()
        let oldIndexPath = IndexPath(row: oldRow, section: 0)
        tableView.reloadRows(at: [oldIndexPath], with: .none)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }


}
