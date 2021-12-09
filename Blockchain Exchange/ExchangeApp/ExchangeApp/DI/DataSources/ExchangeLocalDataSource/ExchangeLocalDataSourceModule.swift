//
//  ExchangeLocalDataSourceModule.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 09/12/2021.
//

import Foundation
import Cleanse
import RxSwift
import ExchangeLocalDataSource

struct ExchangeLocalDataSourceModule: Module {
    static func configure(binder: Cleanse.Binder<Singleton>) {
        binder
            .bind(LocalStorageEngine.self)
            .to {
                let dispatchQueue = DispatchQueue(label: "com.navia.localstoragequeue")
                let serialScheduler = SerialDispatchQueueScheduler(queue: dispatchQueue, internalSerialQueueName: "com.navia.localstoragequeue")
                return LocalStorageEngine(serialScheduler: serialScheduler, fileManager: .default, jsonEncoder: JSONEncoder(), jsonDecoder: JSONDecoder())
            }

        binder
            .bind(ExchangeLocalDataSource.self)
            .to { (storage: LocalStorageEngine) in
                ExchangeLocalDataSource(engine: storage)
            }
    }
}
