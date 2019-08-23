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

    let myDataSource = ["ff0000", "00ff00", "0000ff"]


    // MARK: Life Cycle


    // MARK: TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataSource.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.CellID.randomHistoryCell) as? RandomHistoryCell
        cell?.selectionStyle = .none
        cell?.hexValueLabel.text = myDataSource[indexPath.row]
        cell?.rgbValueLabel.text = rgbFrom(hex: myDataSource[indexPath.row])
        cell?.colorView.backgroundColor = uiColorFrom(hex: myDataSource[indexPath.row])
        cell?.accessoryType = .none

        return cell ?? UITableViewCell()

    }

}
