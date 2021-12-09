//
//  URLSessionDataTaskMock.swift
//  ExchangeAPITests
//
//  Created by Piotr Olechnowicz on 03/12/2021.
//

@testable import ExchangeRemoteDataSource

class URLSessionDataTaskMock: URLSessionDataTaskInterface {

    var invokedResume = false
    var invokedResumeCount = 0

    func resume() {
        invokedResume = true
        invokedResumeCount += 1
    }

    var invokedCancel = false
    var invokedCancelCount = 0

    func cancel() {
        invokedCancel = true
        invokedCancelCount += 1
    }
}
