//
//  ExchangeServiceModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import Reachability
import ExchangeSymbolsRepository
import ExchangeLocalDataSource
import ExchangeRemoteDataSource
import Cleanse

struct ExchangeRepositoryModule: Module {
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
            .bind(ExchangeSymbolsRepository.self)
            .to { (apiClient: ExchangeRemoteDataSourceInterface, localDataSource: ExchangeLocalDataSource, networkInfo: NetworkInfo) in

                return ExchangeSymbolsRepository(apiClient: apiClient,
                                              localDataSource: localDataSource, networkInfo: networkInfo)
            }
    }
}
