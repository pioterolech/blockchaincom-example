//
//  SymbolDetail.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import Charts

final class SymbolsDetailViewController: UIViewController {
    private let disposeBag: DisposeBag = .init()
    private var presenter: SymbolDetailViewPresenterInterface
    private var symbol: String
    private var chartView: LineChartView

    init(presenter: SymbolDetailViewPresenterInterface, symbol: String, chartView: LineChartView) {
        self.presenter = presenter
        self.symbol = symbol
        self.chartView = chartView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom

        view.addSubviewAndFill(chartView)
        view.backgroundColor = .white

        title = symbol

        fetchDataBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.input.accept(SymbolDetailViewPresenterInput.FetchPrices(symbol: symbol))
    }

    private func fetchDataBindings() {
        let success = presenter.output.compactMap { $0 as? SymbolDetailViewPresenterOutput.PricesFetchSuccess }

        success.map { $0 }.drive(reloadChartData).disposed(by: disposeBag)
    }
}

private extension SymbolsDetailViewController {
    var reloadChartData: Binder<SymbolDetailViewPresenterOutput.PricesFetchSuccess> {
        return Binder(self) { view, eventData in
            view.chartView.data = eventData.chartData
//            view.chartView.animate(xAxisDuration: 1)
        }
    }
}
