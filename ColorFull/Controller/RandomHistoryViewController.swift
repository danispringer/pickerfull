//
//  RandomHistoryViewController.swift
//  ColorFull
//
//  Created by Daniel Springer on 8/22/19.
//  Copyright © 2019 Dani Springer. All rights reserved.
//

import UIKit


class RandomHistoryViewController: UIViewController,
UITableViewDelegate,
UITableViewDataSource {


    // MARK: Outlets

    @IBOutlet weak var randomHistoryTableView: UITableView!


    // MARK: Properties

    var myNewDataSource: [String] = [""]


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        readFromDocuments()

    }


    // MARK: Helpers

    func readFromDocuments() {
        let fileManager = FileManager.default

        do {
            let documentDirectory = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false)
            let fileURL = documentDirectory.appendingPathComponent(Constants.Values.colorsFilename)
            let gottenString = try String(contentsOf: fileURL, encoding: .utf8)
            myNewDataSource = gottenString.components(separatedBy: "\n")
            print(myNewDataSource)
        } catch {
            print("error reading: \(error)")
        }

        // add user generated random color to array
        // save new array as string to file

        // write
//        do {
//            let documentDirectory = try fileManager.url(
//                for: .documentDirectory,
//                in: .userDomainMask,
//                appropriateFor: nil,
//                create: false)
//            let fileURL = documentDirectory.appendingPathComponent("colors.txt")
//            let colorsArray = ["ff0000", "ff00ff", "00ff00"]
//            let colorsString = colorsArray.joined(separator: "\n")
//
//            try colorsString.write(to: fileURL, atomically: false, encoding: .utf8)
//
//        } catch {
//            print("error writing: \(error)")
//        }
        }


    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true)
    }


    // MARK: TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if myNewDataSource.count == 0 {
        // TODO: update UI to reflect that table is empty
        }
        // TODO: update UI to reflect that table is NOT empty
        return myNewDataSource.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.CellID.randomHistoryCell) as? RandomHistoryCell else {
                return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.hexValueLabel.text = myNewDataSource[indexPath.row]
        cell.rgbValueLabel.text = rgbFrom(hex: myNewDataSource[indexPath.row])
        cell.colorView.backgroundColor = uiColorFrom(hex: myNewDataSource[indexPath.row])
        cell.accessoryType = .none

        return cell

    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
