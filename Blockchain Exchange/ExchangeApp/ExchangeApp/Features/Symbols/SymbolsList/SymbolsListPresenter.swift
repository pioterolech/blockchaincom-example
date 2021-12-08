//
//  SymbolsListPresenter.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 06/12/2021.
//

import Foundation
import ExchangeServices
import RxSwift
import RxSwiftExt
import RxCocoa

protocol SymbolsListPresenterInterface {
    var input: PublishRelay<SymbolsListPresenterInputInterface> { get }
    var output: Driver<SymbolsListPresenterOutputInterface> { get }
}

protocol SymbolsListPresenterInputInterface { }
protocol SymbolsListPresenterOutputInterface { }

struct SymbolsListPresenterInput {
    struct FetchSymbols: SymbolsListPresenterInputInterface { }
}

struct SymbolsListPresenterOutput {
    struct SymbolsFetchSuccess: SymbolsListPresenterOutputInterface { let symbols: [String] }
    struct SymbolsFetchFailed: SymbolsListPresenterOutputInterface { }
    struct InternalError: SymbolsListPresenterOutputInterface { let errorReason: String }
}

class SymbolsListPresenter: SymbolsListPresenterInterface {
    typealias Input = SymbolsListPresenterInput
    typealias Output = SymbolsListPresenterOutput

    var input: PublishRelay<SymbolsListPresenterInputInterface>
    var output: Driver<SymbolsListPresenterOutputInterface> {
        driverRelay.asDriver(onErrorJustReturn: Output.InternalError(errorReason: "") )
    }
    private let disposeBag = DisposeBag()
    private let symbolsService: ExchangeSymbolsServiceInterface
//    private weak var router: SymbolsRouterInterface?
    private var driverRelay: PublishRelay<SymbolsListPresenterOutputInterface>

    init(symbolsService: ExchangeSymbolsServiceInterface) {
        self.symbolsService = symbolsService
//        self.router = router
        self.input = .init()
        self.driverRelay = .init()

        setupBindings()
    }

    func setupBindings() {
        let fetchSymbolsInput = input.filter { $0 is Input.FetchSymbols }
        let fetchResult = fetchSymbolsInput.append(weak: self).flatMap { presenter, _ in
            presenter.symbolsService.symbols().materialize()
        }
//
        fetchResult.elements()
                   .map { Output.SymbolsFetchSuccess(symbols: $0) }
                   .bind(to: driverRelay)
                   .disposed(by: disposeBag)

        fetchResult.errors()
                    .map { _ in Output.SymbolsFetchFailed() }
                    .bind(to: driverRelay)
                    .disposed(by: disposeBag)
    }
}
