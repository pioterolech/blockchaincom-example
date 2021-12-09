//
//  ExchangeServiceModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import Reachability
import ExchangeServices
import ExchangeLocalDataSource
import ExchangeRemoteDataSource
import Cleanse

struct ExchangeServiceModule: Module {
    static func configure(binder: Binder<Singleton>) {

        binder.bind(Reachability.self)
              .to {
                  try! Reachability()
              }

        binder
            .bind(NetworkInfo.self)
            .to { (reachability: Reachability) in
                NetworkInfo(reachability: reachability)
            }

        binder
            .bind(ExchangeSymbolsService.self)
            .to { (apiClient: ExchangeRemoteDataSourceInterface, localDataSource: ExchangeLocalDataSource, networkInfo: NetworkInfo) in

                return ExchangeSymbolsService(apiClient: apiClient,
                                              localDataSource: localDataSource, networkInfo: networkInfo)
            }
    }
}
