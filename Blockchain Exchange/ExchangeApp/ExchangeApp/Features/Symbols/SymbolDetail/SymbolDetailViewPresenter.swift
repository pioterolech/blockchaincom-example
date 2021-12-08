//
//  SymbolsDetailViewPresenter.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import ExchangeServices

protocol SymbolDetailViewPresenterInterface {

}

final class SymbolDetailViewPresenter: SymbolDetailViewPresenterInterface {
    private let symbolsService: ExchangeSymbolsServiceInterface

    init(symbolsService: ExchangeSymbolsServiceInterface) {
        self.symbolsService = symbolsService
    }
}
