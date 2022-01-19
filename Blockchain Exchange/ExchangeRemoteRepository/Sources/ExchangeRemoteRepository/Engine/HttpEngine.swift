//
//  File.swift
//  
//
//  Created by Piotr Olechnowicz on 02/12/2021.
//

import Foundation
import Combine

public protocol HttpEngingeInterface {
    func fetch<T: Codable>(with url: String) -> AnyPublisher<T, HttpEngineError>
}

public class HttpEngine: HttpEngingeInterface {
    private let urlSession: URLSessionInterface
    private let decoder: JSONDecoder

    public init(urlSession: URLSessionInterface, decoder: JSONDecoder) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    public func fetch<T: Codable>(with url: String) -> AnyPublisher<T, HttpEngineError> {
        combineFetch(with: url).tryMap { [unowned self] data in
            try self.decoder.decode(T.self, from: data)
        }
        .mapError({ .enigneError($0) })
        .eraseToAnyPublisher()
    }

    private func combineFetch(with url: String) -> AnyPublisher<Data, HttpEngineError> {
        do {
            let request = try URLRequest.create(from: url)
            return urlSession.fetch(for: request)
                             .tryMap { try HttpEngine.handleResponse(data: $0.data, response: $0.response) }
                             .mapError({ .enigneError($0) })
                             .eraseToAnyPublisher()
        } catch {
            return Fail(error: .enigneError(error)).eraseToAnyPublisher()
        }
    }

    private static func handleResponse(data: Data, response: URLResponse) throws -> Data {
        guard let response = (response as? HTTPURLResponse) else {
            throw HttpEngineError.invalidResponse
        }

        guard response.isSuccess else {
            throw HttpEngineError.error(for: response.statusCode)
        }

        return data
    }
}

private extension HTTPURLResponse {
    var isSuccess: Bool {
        return (100...299).contains(statusCode)
    }
}

private extension URLRequest {
    static func create(from url: String) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw HttpEngineError.invalidURL(url)
        }

        return URLRequest(url: url)
    }
}
