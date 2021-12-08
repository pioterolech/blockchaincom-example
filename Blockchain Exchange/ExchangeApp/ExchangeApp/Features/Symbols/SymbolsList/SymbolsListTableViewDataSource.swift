//
//  SymbolsListTableViewDataSource.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 07/12/2021.
//

import Foundation
import UIKit
import RxCocoa

final class SymbolsListTableViewDataSource: NSObject, UITableViewDataSource {
    private(set) var dataRelay: BehaviorRelay<[String]>

    init(dataRelay: BehaviorRelay<[String]>) {
        self.dataRelay = dataRelay
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataRelay.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") else {
            return UITableViewCell()
        }

        var config = cell.defaultContentConfiguration()

        config.text = dataRelay.value[indexPath.row]
        cell.backgroundColor = .white
        cell.contentConfiguration = config

        return cell
    }
}
