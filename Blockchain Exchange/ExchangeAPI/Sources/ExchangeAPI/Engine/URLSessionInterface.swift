//
//  URLSessionInterface.swift
//  ExchangeAPITests
//
//  Created by Piotr Olechnowicz on 03/12/2021.
//

import Foundation

public typealias TaskCompletion = (Data?, URLResponse?, Error?) -> Void

public protocol URLSessionInterface {
    func createDataTask(with request: URLRequest,
                        completionHandler: @escaping TaskCompletion) -> URLSessionDataTaskInterface
}

public protocol URLSessionDataTaskInterface {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskInterface { }
extension URLSession: URLSessionInterface {
    public func createDataTask(with request: URLRequest,
                               completionHandler: @escaping TaskCompletion) -> URLSessionDataTaskInterface {
        dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskInterface
    }
}
