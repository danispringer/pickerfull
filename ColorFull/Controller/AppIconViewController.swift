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
    let myDataSource = Array(0...1).map { "\($0)" }
    let colorNames = ["Purple on White", "White on Purple"]


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        updateTheme()
    }


    // MARK: Helpers

    func updateTheme() {

        let darkMode = traitCollection.userInterfaceStyle == .dark

        backgroundColor = darkMode ? .black : .white
        textColor = darkMode ? .white : .black

        myLabel.textColor = textColor
        myToolbar.barTintColor = darkMode ? .black : .white
        view.backgroundColor = darkMode ? .black : .white
        myTableView.reloadData()
    }


    func updateIcon() {
        let newIconNumberValue = UserDefaults.standard.integer(forKey: Constants.UserDef.selectedIcon)
        print("newIconNumberValue: \(newIconNumberValue)")

        guard UIApplication.shared.supportsAlternateIcons else {
            print("NOTE: alternate icons not supported")
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


    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateTheme()
    }


    // MARK: TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataSource.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let darkMode = traitCollection.userInterfaceStyle == .dark

        tableView.backgroundColor = backgroundColor
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellID.cellID) as? MyCell
        cell?.selectionStyle = .none
        cell?.myImageView?.image = UIImage(named: "\(indexPath.row)")
        cell?.backgroundColor = backgroundColor
        cell?.contentView.backgroundColor = backgroundColor
        cell?.myLabel.textColor = textColor
        cell?.myLabel.text = colorNames[indexPath.row]
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
        tableView.reloadData() // to remove previous checkmark. any cleaner way?
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }


}
