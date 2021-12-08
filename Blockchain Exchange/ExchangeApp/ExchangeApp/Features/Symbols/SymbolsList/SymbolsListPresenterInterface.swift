//
//  SymbolsListPresenterInterface.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import RxCocoa

protocol SymbolsListPresenterInputInterface { }
protocol SymbolsListPresenterOutputInterface { }
protocol SymbolsListPresenterInterface {
    var input: PublishRelay<SymbolsListPresenterInputInterface> { get }
    var output: Driver<SymbolsListPresenterOutputInterface> { get }
}

struct SymbolsListPresenterInput {
    struct FetchSymbols: SymbolsListPresenterInputInterface { }
    struct DidSelectItem: SymbolsListPresenterInputInterface { let index: Int }
}

struct SymbolsListPresenterOutput {
    struct SymbolsFetchSuccess: SymbolsListPresenterOutputInterface { let symbols: [String] }
    struct SymbolsFetchFailed: SymbolsListPresenterOutputInterface { }
    struct InternalError: SymbolsListPresenterOutputInterface { let errorReason: String }
}
