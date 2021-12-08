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
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = 44

        view.backgroundColor = .red
        title = "Symbol view"

        view.addSubviewAndFill(tableView)

        setupBindings()

        presenter.input.accept(SymbolsListPresenterInput.FetchSymbols())
    }

    private func setupBindings() {
        let success = presenter.output.compactMap { $0 as? SymbolsListPresenterOutput.SymbolsFetchSuccess }
        let failure = presenter.output.compactMap { $0 as? SymbolsListPresenterOutput.SymbolsFetchFailed }
        let startFetch = presenter.input.compactMap { $0 as? SymbolsListPresenterInput.FetchSymbols }

        let indicatorState = Observable.merge(success.asObservable().mapTo(false), failure.asObservable().mapTo(false), startFetch.mapTo(true))
        indicatorState.bind(to: view.rx.showActivityIndicator).disposed(by: disposeBag)

        success.map { $0.symbols }.drive(rx.reloadData).disposed(by: disposeBag)
    }
}

extension Reactive where Base: SymbolsListViewController {
    var reloadData: Binder<[String]> {
        return Binder(self.base) { view, data in
            view.dataSource.dataRelay.accept(data)
            view.tableView.reloadData()
        }
    }
}
