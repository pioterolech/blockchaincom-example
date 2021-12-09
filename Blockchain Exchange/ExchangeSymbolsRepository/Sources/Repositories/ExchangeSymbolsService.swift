//
//  ExchangeSymbolsService.swift
//  ExchangeServices
//
//  Created by Piotr Olechnowicz on 05/12/2021.
//

import ExchangeRemoteDataSource
import ExchangeLocalDataSource
import Foundation
import RxSwift

public protocol ExchangeSymbolsRepositoryInterface {
    func symbols() -> Observable<[String]>
    func prices(symbol: String) -> Observable<[[Double]]>
}

public final class ExchangeSymbolsRepository: ExchangeSymbolsRepositoryInterface {
    private let apiClient: ExchangeRemoteDataSourceInterface
    private let localDataSource: ExchangeLocalDataSource
    private let networkInfo: NetworkInfoInterface

    public init(apiClient: ExchangeRemoteDataSourceInterface,
                localDataSource: ExchangeLocalDataSource,
                networkInfo: NetworkInfoInterface) {
        self.apiClient = apiClient
        self.localDataSource = localDataSource
        self.networkInfo = networkInfo
    }

    public func symbols() -> Observable<[String]> {
        guard networkInfo.isReachable else {
            return localDataSource.getSymbols().map { $0.symbols }
        }

        return apiClient.symbols().map { Array($0.keys) }.append(weak: localDataSource)
                        .flatMap { dataService, symbols -> Observable<SymbolsDataSourceEntity> in
                            let dataEntity = SymbolsDataSourceEntity(symbols: symbols)
                            return dataService.saveSymbols(symbols: dataEntity)
                        }.map { $0.symbols }
    }

    public func prices(symbol: String) -> Observable<[[Double]]> {
        guard networkInfo.isReachable else {
            return Observable.just([])
        }

        return apiClient.prices(symbol: symbol).map { $0.prices }
    }
}

private extension ObservableType {
    func append<A: AnyObject>(weak obj: A) -> Observable<(A, Element)> {
        return flatMap { [weak obj] value -> Observable<(A, Element)> in
            guard let obj = obj else { return .empty() }
            return Observable.just((obj, value))
        }
    }
}
