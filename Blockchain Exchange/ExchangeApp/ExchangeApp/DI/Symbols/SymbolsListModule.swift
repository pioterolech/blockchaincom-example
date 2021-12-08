//
//  SymbolsModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 07/12/2021.
//

import Foundation
import Cleanse
import UIKit
import ExchangeServices

struct SymbolsListModule: Module {
    static func configure(binder: Binder<Unscoped>) {
        binder
            .bind(SymbolsListPresenter.self)
            .to { (service: ExchangeSymbolsService) in
                SymbolsListPresenter(symbolsService: service)
            }

        binder
            .bind(SymbolsListViewController.self)
            .to { (presenter: SymbolsListPresenter) in
                let tableView = UITableView()
                let dataSource = SymbolsListTableViewDataSource(dataRelay: .init(value: ["String1", "String2"]))
                return SymbolsListViewController(tableView: tableView, dataSource: dataSource, presenter: presenter)
            }
    }
}
