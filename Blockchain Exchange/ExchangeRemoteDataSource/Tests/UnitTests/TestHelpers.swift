//
//  TestHelpers.swift
//  ExchangeRemoteDataSourceTests
//
//  Created by Piotr Olechnowicz on 13/01/2022.
//

import Foundation
import XCTest
import Combine

class ValueSpy<T, E: Error & Equatable> {
    private(set) var values = [T]()
    private(set) var completion: Subscribers.Completion<E>?

    private var cancellable: AnyCancellable?

    init(_ publisher: AnyPublisher<T, E>) {
        cancellable = publisher.sink(receiveCompletion: { [weak self] completion in
            self?.completion = completion
        }, receiveValue: { [weak self] value in
            self?.values.append(value)
        })
    }
}

func XCTAssertCompletion<E: Error & Equatable>(completion: Subscribers.Completion<E>?, error: E) {
    XCTAssertNotNil(completion)
    if case let .failure(completionError) = completion {
        XCTAssertEqual(completionError, error)
    } else {
        XCTFail("Completion is not failure")
    }
}
