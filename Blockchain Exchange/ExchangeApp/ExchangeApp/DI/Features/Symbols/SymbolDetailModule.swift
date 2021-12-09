//
//  SymbolDetailModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import Cleanse
import UIKit
import Charts
import ExchangeSymbolsRepository

struct SymbolsDetailAssistedFactory: Cleanse.AssistedFactory {
    typealias Seed = String
    typealias Element = SymbolsDetailViewController
}

struct SymbolDetailModule: Module {
    static func configure(binder: Binder<Unscoped>) {

        binder
            .bind(SymbolDetailViewPresenter.self)
            .to { (service: ExchangeSymbolsRepository) in
                return SymbolDetailViewPresenter(symbolsService: service)
            }

        binder
            .bind(LineChartView.self)
            .to {
                return LineChartView()
            }

        binder
            .bindFactory(SymbolsDetailViewController.self)
            .with(SymbolsDetailAssistedFactory.self)
            .to { (presenter: SymbolDetailViewPresenter, chartView: LineChartView, factory: Assisted<String>) in
                return SymbolsDetailViewController(presenter: presenter, symbol: factory.get(), chartView: chartView)
            }
    }
}
