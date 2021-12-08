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
                return SymbolsListPresenter(symbolsService: service)
            }

        binder
            .bind(SymbolsListViewController.self)
            .to { (presenter: SymbolsListPresenter) in
                let tableView = UITableView()
                let dataSource = SymbolsListTableViewDataSource(dataRelay: .init(value: []))
                return SymbolsListViewController(tableView: tableView, dataSource: dataSource, presenter: presenter)
            }
    }
}
