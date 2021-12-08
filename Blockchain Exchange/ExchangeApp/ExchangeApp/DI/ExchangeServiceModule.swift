//
//  ExchangeServiceModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import ExchangeServices
import ExchangeAPI
import Cleanse

struct ExchangeServiceModule: Module {
    static func configure(binder: Binder<Singleton>) {

        binder
            .bind(ExchangeSymbolsService.self)
            .to { (apiClient: ExchangeAPIInterface) in
                return ExchangeSymbolsService(apiClient: apiClient)
            }
    }
}
