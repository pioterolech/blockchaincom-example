//
//  URLSessionMock.swift
//  ExchangeAPITests
//
//  Created by Piotr Olechnowicz on 03/12/2021.
//

@testable import ExchangeRemoteDataSource
import Foundation
import Combine

class URLSessionMock: URLSessionInterface {

    var invokedFetch = false
    var invokedFetchCount = 0
    var invokedFetchParameters: (request: URLRequest, Void)?
    var invokedFetchParametersList = [(request: URLRequest, Void)]()
    var stubbedFetchResult: AnyPublisher<(data: Data, response: URLResponse), URLError>!

    func fetch(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        invokedFetch = true
        invokedFetchCount += 1
        invokedFetchParameters = (request, ())
        invokedFetchParametersList.append((request, ()))
        return stubbedFetchResult
    }
}
