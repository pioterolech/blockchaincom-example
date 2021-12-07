//
//  SymbolsModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 07/12/2021.
//

import Foundation
import Cleanse
import UIKit

struct SymbolsModule: Module {
    static func configure(binder: Binder<Unscoped>) {
        binder
            .bind(SymbolsListViewController.self)
            .to {
                let tableView = UITableView()
                let dataSource = SymbolsListTableViewDataSource(dataRelay: .init(value: ["String1", "String2"]))
                return SymbolsListViewController(tableView: tableView, dataSource: dataSource)
            }
    }
}
