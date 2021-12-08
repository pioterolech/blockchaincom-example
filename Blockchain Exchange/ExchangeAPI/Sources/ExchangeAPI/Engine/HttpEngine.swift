//
//  File.swift
//  
//
//  Created by Piotr Olechnowicz on 02/12/2021.
//

import Foundation
import RxSwift

public protocol HttpEngingeInterface {
    func fetch<T: Codable>(with url: String) -> Observable<T>
}

public class HttpEngine: HttpEngingeInterface {
    private let urlSession: URLSessionInterface
    private let decoder: JSONDecoder

    public init(urlSession: URLSessionInterface, decoder: JSONDecoder) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    public func fetch<T: Codable>(with url: String) -> Observable<T> {
        fetch(with: url).decode(type: T.self, decoder: decoder)
    }

    private func fetch(with url: String) -> Observable<Data> {
        Observable.create { [weak self] observer in
            let task = self?.dataTask(with: url, observer: observer)
            task?.resume()

            return Disposables.create {
                task?.cancel()
            }
        }
    }

    private func dataTask(with url: String, observer: AnyObserver<Data>) -> URLSessionDataTaskInterface? {
        guard let url = URL(string: url) else {
            observer.onError(HttpEngineErrors.invalidURL)
            return nil
        }

        return urlSession.createDataTask(with: URLRequest(url: url)) { data, response, error in

            // MARK: - Trasport error, timeout, connection refused etc.

            if let error = error {
                observer.onError(error)
                return
            }

            guard let response = (response as? HTTPURLResponse) else {
                observer.onError(HttpEngineErrors.invalidResponse)
                return
            }

            guard response.isSuccess else {
                observer.onError(HttpEngineErrors.error(for: response.statusCode))
                return
            }

            guard let data = data else {
                observer.onError(HttpEngineErrors.emptyResponse)
                return
            }

            // MARK: - Success

            observer.onNext(data)
        }
    }
}

private extension HTTPURLResponse {
    var isSuccess: Bool {
        return (100...299).contains(statusCode)
    }
}
