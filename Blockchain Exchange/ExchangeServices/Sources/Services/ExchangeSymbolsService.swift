//
//  ExchangeSymbolsService.swift
//  ExchangeServices
//
//  Created by Piotr Olechnowicz on 05/12/2021.
//

import ExchangeAPI
import Foundation
import RxSwift

public protocol ExchangeSymbolsServiceInterface {
    func symbols() -> Observable<[String]>
    func prices(symbol: String) -> Observable<[[Double]]>
}

public final class ExchangeSymbolsService: ExchangeSymbolsServiceInterface {
    private let apiClient: ExchangeAPIInterface

    public init(apiClient: ExchangeAPIInterface) {
        self.apiClient = apiClient
    }

    public func symbols() -> Observable<[String]> {
        apiClient.symbols().map { Array($0.keys) }
    }

    public func prices(symbol: String) -> Observable<[[Double]]> {
        apiClient.prices(symbol: symbol).map { $0.prices }
    }
}
