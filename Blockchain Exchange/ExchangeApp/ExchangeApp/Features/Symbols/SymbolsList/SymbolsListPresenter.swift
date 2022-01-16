//
//  SymbolsListPresenter.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 06/12/2021.
//

import Foundation
import ExchangeSymbolsRepository
import RxSwift
import RxSwiftExt
import RxCocoa

final class SymbolsListPresenter: SymbolsListPresenterInterface {
    typealias Input = SymbolsListPresenterInput
    typealias Output = SymbolsListPresenterOutput

    weak var router: SymbolsRouterInterface?
    var input: PublishRelay<SymbolsListPresenterInputInterface>
    var output: Driver<SymbolsListPresenterOutputInterface> {
        driverRelay.asDriver(onErrorJustReturn: Output.InternalError(errorReason: "") )
    }

    private let disposeBag = DisposeBag()
    private let symbolsService: ExchangeSymbolsRepositoryInterface
    private var driverRelay: BehaviorRelay<SymbolsListPresenterOutputInterface>
    private var currentElements: BehaviorRelay<[String]>

    init(symbolsService: ExchangeSymbolsRepositoryInterface) {
        self.symbolsService = symbolsService
        self.input = .init()
        self.driverRelay = .init(value: Output.ViewInit())
        self.currentElements = .init(value: [])

        setupFetchBindings()
        setupDetailsBindings()
    }

    private func setupFetchBindings() {
        let fetchSymbolsInput = input.filter { $0 is Input.FetchSymbols }
        let fetchResult = fetchSymbolsInput.flatMap { [unowned self] _ in
            self.symbolsService.symbols().materialize()
        }.share()

        fetchResult.elements()
                   .map { Output.SymbolsFetchSuccess(symbols: $0) }
                   .bind(to: driverRelay)
                   .disposed(by: disposeBag)

        fetchResult.elements().bind(to: currentElements).disposed(by: disposeBag)

        fetchResult.errors()
                    .map { _ in Output.SymbolsFetchFailed() }
                    .bind(to: driverRelay)
                    .disposed(by: disposeBag)
    }

    private func setupDetailsBindings() {
        let fetchSymbolsInput = input.compactMap { $0 as? Input.DidSelectItem }
                                     .append(weak: self)
                                     .filter { $0.currentElements.value.count > $1.index }
                                     .map { $0.currentElements.value[$1.index] }

        fetchSymbolsInput.bind(to: showDetailBinder).disposed(by: disposeBag)
    }
}

extension SymbolsListPresenter {
    var showDetailBinder: RxSwift.Binder<String> {
        return Binder(self) { view, data in
            view.router?.showSymbolDetails(symbol: data)
        }
    }
}
