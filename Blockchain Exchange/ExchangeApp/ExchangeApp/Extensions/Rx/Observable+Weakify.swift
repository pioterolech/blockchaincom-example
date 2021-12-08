//
//  Observable+Weakify.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import RxSwift

extension ObservableType {
    func append<A: AnyObject>(weak obj: A) -> Observable<(A, Element)> {
        return flatMap { [weak obj] value -> Observable<(A, Element)> in
            guard let obj = obj else { return .empty() }
            return Observable.just((obj, value))
        }
    }
}
