//
//  ExchangeAPIModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import Cleanse
import ExchangeRemoteDataSource

struct ExchangeRemoteDataSourceModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder
            .bind(HttpEngingeInterface.self)
            .to { HttpEngine(urlSession: URLSession.shared, decoder: .init()) }

        binder
            .bind(URLFactory.self)
            .to { URLFactory.create() }

        binder
            .bind(ExchangeRemoteDataSourceInterface.self)
            .to { (engine: HttpEngingeInterface, urlFactory: URLFactory) in
                ExchangeRemoteDataSource(engine: engine, urlFactory: urlFactory)
            }
    }
}
