//
//  URLSessionMock.swift
//  ExchangeAPITests
//
//  Created by Piotr Olechnowicz on 03/12/2021.
//

@testable import ExchangeAPI
import Foundation

class URLSessionMock: URLSessionInterface {

    var invokedCreateDataTask = false
    var invokedCreateDataTaskCount = 0
    var invokedCreateDataTaskParameters: (request: URLRequest, Void)?
    var invokedCreateDataTaskParametersList = [(request: URLRequest, Void)]()
    var stubbedCreateDataTaskCompletionHandlerResult: (Data?, URLResponse?, Error?)?
    var stubbedCreateDataTaskResult: URLSessionDataTaskInterface!

    func createDataTask(with request: URLRequest,
        completionHandler: @escaping TaskCompletion) -> URLSessionDataTaskInterface {
        invokedCreateDataTask = true
        invokedCreateDataTaskCount += 1
        invokedCreateDataTaskParameters = (request, ())
        invokedCreateDataTaskParametersList.append((request, ()))
        if let result = stubbedCreateDataTaskCompletionHandlerResult {
            completionHandler(result.0, result.1, result.2)
        }
        return stubbedCreateDataTaskResult
    }
}
