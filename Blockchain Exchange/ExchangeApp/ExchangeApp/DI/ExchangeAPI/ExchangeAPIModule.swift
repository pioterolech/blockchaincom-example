//
//  ExchangeAPIModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import Cleanse
import ExchangeAPI

struct ExchangeAPIModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder
            .bind(HttpEngingeInterface.self)
            .to { HttpEngine(urlSession: URLSession.shared, decoder: .init()) }

        binder
            .bind(URLFactory.self)
            .to { URLFactory.create() }

        binder
            .bind(ExchangeAPIInterface.self)
            .to { (engine: HttpEngingeInterface, urlFactory: URLFactory) in
                ExchangeAPI(engine: engine, urlFactory: urlFactory)
            }
    }
}
