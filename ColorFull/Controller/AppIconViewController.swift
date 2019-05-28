//
//  AppIconViewController.swift
//  ColorFull
//
//  Created by Daniel Springer on 5/27/19.
//  Copyright © 2019 Dani Springer. All rights reserved.
//

import UIKit


class AppIconViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    // MARK: Outlets

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var myLabel: UILabel!


    // MARK: Properties

    var textColor: UIColor! = nil
    var backgroundColor: UIColor! = nil
    let myDataSource = Array(0...13).map { "\($0)" }


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let darkMode = UserDefaults.standard.bool(forKey: Constants.UserDef.darkModeIsOn)

        myToolbar.barTintColor = darkMode ? .black : .white
        view.backgroundColor = darkMode ? .black : .white
        textColor = darkMode ? .white : .black
        backgroundColor = darkMode ? .black : .white
        myLabel.textColor = textColor


    }


    // MARK: Helpers


    func updateIcon() {
        let newIconNumberValue = UserDefaults.standard.integer(forKey: Constants.UserDef.selectedIcon)
        print("newIconNumberValue: \(newIconNumberValue)")

        guard UIApplication.shared.supportsAlternateIcons else {
            print("NOTE: alternate icons not supported")
            return
        }

        UIApplication.shared.setAlternateIconName("\(newIconNumberValue)") { error in
            if let error = error {
                print("App icon failed to change due to \(error.localizedDescription)")
            } else {
                print("app icon should now be updated")
            }
        }
    }


    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    // MARK: TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataSource.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let darkMode = UserDefaults.standard.bool(forKey: Constants.UserDef.darkModeIsOn)
        tableView.backgroundColor = darkMode ? .black : .white
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellID.cellID) as? MyCell
        cell?.selectionStyle = .none
        cell?.myImageView?.image = UIImage(named: "\(indexPath.row)")
        cell?.backgroundColor = darkMode ? .black : .white
        cell?.contentView.backgroundColor = darkMode ? .black : .white
        cell?.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        cell?.accessoryType = .none

        let myIndexPath = IndexPath(
            row: UserDefaults.standard.integer(forKey: Constants.UserDef.selectedIcon),
            section: 0)
        if indexPath == myIndexPath {
            cell?.accessoryType = .checkmark
        }

        tableView.separatorColor = darkMode ? .darkGray : .lightGray
        tableView.indicatorStyle = darkMode ? .white : .black


        return cell ?? UITableViewCell()
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: Constants.UserDef.selectedIcon)
        print("Constants...selectedIcon): \(UserDefaults.standard.integer(forKey: Constants.UserDef.selectedIcon))")
        updateIcon()
        tableView.reloadData() // TODO: to remove previous checkmark. any cleaner way?
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }


}
