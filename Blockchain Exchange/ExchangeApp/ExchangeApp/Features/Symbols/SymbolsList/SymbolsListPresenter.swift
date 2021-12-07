//
//  SymbolsListPresenter.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 06/12/2021.
//

import Foundation
import ExchangeServices
import RxSwift
import RxCocoa

protocol SymbolsListPresenterInterface {

}

class SymbolsListPresenter: SymbolsListPresenterInterface {
    private let symbolsService: ExchangeSymbolsServiceInterface
    private let router: SymbolsRouterInterface

    init(symbolsService: ExchangeSymbolsServiceInterface, router: SymbolsRouterInterface) {
        self.symbolsService = symbolsService
        self.router = router
    }

    func symbolsList() -> Observable<[String]> {

        return symbolsService.symbols()
    }
}
