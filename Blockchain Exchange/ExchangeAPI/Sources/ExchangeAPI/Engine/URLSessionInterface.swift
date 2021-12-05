//
//  URLSessionInterface.swift
//  ExchangeAPITests
//
//  Created by Piotr Olechnowicz on 03/12/2021.
//

import Foundation

typealias TaskCompletion = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionInterface {
    func createDataTask(with request: URLRequest,
                        completionHandler: @escaping TaskCompletion) -> URLSessionDataTaskInterface
}

protocol URLSessionDataTaskInterface {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskInterface { }
extension URLSession: URLSessionInterface {
    func createDataTask(with request: URLRequest,
                        completionHandler: @escaping TaskCompletion) -> URLSessionDataTaskInterface {
        dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskInterface
    }
}
