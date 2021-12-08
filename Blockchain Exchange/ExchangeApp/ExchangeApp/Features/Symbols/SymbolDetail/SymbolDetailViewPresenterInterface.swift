//
//  SymbolDetailViewPresenterInterface.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import RxCocoa
import Charts

protocol SymbolDetailViewPresenterInputInterface { }
protocol SymbolDetailViewPresenterOutputInterface { }

protocol SymbolDetailViewPresenterInterface {
    var input: PublishRelay<SymbolDetailViewPresenterInputInterface> { get }
    var output: Driver<SymbolDetailViewPresenterOutputInterface> { get }
}

struct SymbolDetailViewPresenterInput {
    struct FetchPrices: SymbolDetailViewPresenterInputInterface { let symbol: String }
}

struct SymbolDetailViewPresenterOutput {
    struct PricesFetchSuccess: SymbolDetailViewPresenterOutputInterface { let chartData: LineChartData }
    struct PricesFetchFailed: SymbolDetailViewPresenterOutputInterface { }
    struct InternalError: SymbolDetailViewPresenterOutputInterface { let errorReason: String }
}
