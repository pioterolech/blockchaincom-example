//
//  URLSessionInterface.swift
//  ExchangeAPITests
//
//  Created by Piotr Olechnowicz on 03/12/2021.
//

import Foundation
import Combine

public protocol URLSessionInterface {
    func fetch(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

extension URLSession: URLSessionInterface {
    public func fetch(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
