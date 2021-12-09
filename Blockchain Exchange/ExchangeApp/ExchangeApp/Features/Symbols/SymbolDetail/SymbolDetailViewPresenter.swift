//
//  SymbolsDetailViewPresenter.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import RxCocoa
import RxSwift
import ExchangeSymbolsRepository
import Charts

final class SymbolDetailViewPresenter: SymbolDetailViewPresenterInterface {
    typealias Input = SymbolDetailViewPresenterInput
    typealias Output = SymbolDetailViewPresenterOutput

    var input: PublishRelay<SymbolDetailViewPresenterInputInterface>
    var output: Driver<SymbolDetailViewPresenterOutputInterface> {
        driverRelay.asDriver(onErrorJustReturn: Output.InternalError(errorReason: "") )
    }

    private let disposeBag = DisposeBag()
    private let symbolsService: ExchangeSymbolsRepositoryInterface
    private var driverRelay: PublishRelay<SymbolDetailViewPresenterOutputInterface>

    init(symbolsService: ExchangeSymbolsRepositoryInterface) {
        self.symbolsService = symbolsService
        self.input = .init()
        self.driverRelay = .init()
        setupFetchBindings()
    }

    private func setupFetchBindings() {
        let fetchSymbolsInput = input.compactMap { $0 as? Input.FetchPrices }
        let fetchResult = fetchSymbolsInput.append(weak: self).flatMap { presenter, eventData in
            presenter.symbolsService.prices(symbol: eventData.symbol).materialize()
        }.share()

        fetchResult.elements()
                   .filter { !$0.isEmpty }
                   .map { data in
                       let chartData = data.compactMap { element -> ChartDataEntry? in
                           guard element.count >= 2 else {
                               return nil
                           }
                           let elX = element[0]
                           let elY = element[2]
                           return ChartDataEntry(x: elX, y: elY)
                       }
                       let lineChartDataSet = LineChartDataSet(entries: chartData, label: "Prices")
                       lineChartDataSet.lineWidth = 5
                       lineChartDataSet.drawCirclesEnabled = false
                       lineChartDataSet.setDrawHighlightIndicators(true)
                       let chartDataOutput = LineChartData(dataSet: lineChartDataSet)
                       chartDataOutput.setDrawValues(false)
                       return Output.PricesFetchSuccess(chartData: chartDataOutput)
                   }
                   .bind(to: driverRelay)
                   .disposed(by: disposeBag)

        fetchResult.errors()
                    .map { _ in Output.PricesFetchFailed() }
                    .bind(to: driverRelay)
                    .disposed(by: disposeBag)
    }
}
