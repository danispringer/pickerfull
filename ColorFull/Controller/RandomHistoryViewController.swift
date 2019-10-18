//
//  RandomHistoryViewController.swift
//  ColorFull
//
//  Created by Daniel Springer on 8/22/19.
//  Copyright © 2019 Dani Springer. All rights reserved.
//

import UIKit
import StoreKit


class RandomHistoryViewController: UIViewController,
UITableViewDelegate,
UITableViewDataSource {


    // MARK: Outlets

    @IBOutlet weak var randomHistoryTableView: UITableView!


    // MARK: Properties

    var myDataSource: [String] = [""]


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        readFromDocuments()

    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        SKStoreReviewController.requestReview()
    }


    // MARK: Helpers

    func readFromDocuments() {

        // TODO: fill

    }


    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true)
    }


    // MARK: TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if myDataSource.count == 0 {
        // TODO: update UI to reflect that table is empty
        }
        // TODO: update UI to reflect that table is NOT empty
        return myDataSource.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.CellID.randomHistoryCell) as? RandomHistoryCell else {
                return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.hexValueLabel.text = myDataSource[indexPath.row]
        cell.rgbValueLabel.text = rgbFrom(hex: myDataSource[indexPath.row])
        cell.colorView.backgroundColor = uiColorFrom(hex: myDataSource[indexPath.row])
        cell.accessoryType = .none

        return cell

    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
