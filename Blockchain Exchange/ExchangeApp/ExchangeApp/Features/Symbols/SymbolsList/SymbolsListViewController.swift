//
//  ViewController.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 05/12/2021.
//

import UIKit

class SymbolsListViewController: UIViewController, UITableViewDelegate {
    private let tableView: UITableView
    private weak var dataSource: SymbolsListTableViewDataSource?

    init(tableView: UITableView, dataSource: SymbolsListTableViewDataSource) {
        self.tableView = tableView
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 44
//        tableView.estimatedRowHeight = 44

        view.backgroundColor = .red
        title = "Symbol view"

        view.addSubviewAndFill(tableView)
        tableView.reloadData()
    }
}
