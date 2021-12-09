//
//  ViewController.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 05/12/2021.
//

import UIKit
import RxCocoa
import RxSwift

final class SymbolsListViewController: UIViewController, UITableViewDelegate {
    private(set) var tableView: UITableView
    private(set) var dataSource: SymbolsListTableViewDataSource
    private let presenter: SymbolsListPresenterInterface
    private let disposeBag: DisposeBag = .init()

    init(tableView: UITableView,
         dataSource: SymbolsListTableViewDataSource,
         presenter: SymbolsListPresenterInterface) {
        self.tableView = tableView
        self.dataSource = dataSource
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 44
        tableView.backgroundColor = .white

        view.backgroundColor = .white
        title = "Symbol view"

        view.addSubviewAndFill(tableView)

        fetchDataBindings()
        tableViewSelectionBindings()

        presenter.input.accept(SymbolsListPresenterInput.FetchSymbols())
    }

    private func fetchDataBindings() {
        let success = presenter.output.compactMap { $0 as? SymbolsListPresenterOutput.SymbolsFetchSuccess }
        let failure = presenter.output.compactMap { $0 as? SymbolsListPresenterOutput.SymbolsFetchFailed }
        let startFetch = presenter.input.compactMap { $0 as? SymbolsListPresenterInput.FetchSymbols }

        let indicatorState = Observable.merge(success.asObservable().mapTo(false),
                                              failure.asObservable().mapTo(false),
                                              startFetch.mapTo(true))

        indicatorState.bind(to: view.rx.showActivityIndicator).disposed(by: disposeBag)

        success.map { $0.symbols }.drive(rx.reloadData).disposed(by: disposeBag)
    }

    private func tableViewSelectionBindings() {
        tableView.rx.itemSelected
                 .map { SymbolsListPresenterInput.DidSelectItem(index: $0.row) }
                 .bind(to: presenter.input).disposed(by: disposeBag)
    }
}

private extension Reactive where Base: SymbolsListViewController {
    var reloadData: Binder<[String]> {
        return Binder(self.base) { view, data in
            view.dataSource.dataRelay.accept(data)
            view.tableView.reloadData()
        }
    }
}
