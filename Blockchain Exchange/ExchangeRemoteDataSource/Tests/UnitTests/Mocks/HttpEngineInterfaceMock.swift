@testable import ExchangeRemoteDataSource
import Combine

class HttpEngineMock: HttpEngingeInterface {

    var invokedFetch = false
    var invokedFetchCount = 0
    var invokedFetchParameters: (url: String, Void)?
    var invokedFetchParametersList = [(url: String, Void)]()
    var stubbedFetchResult: AnyPublisher<Any, HttpEngineError>!

    func fetch<T: Codable>(with url: String) -> AnyPublisher<T, HttpEngineError> {
        invokedFetch = true
        invokedFetchCount += 1
        invokedFetchParameters = (url, ())
        invokedFetchParametersList.append((url, ()))
        return stubbedFetchResult as! AnyPublisher<T, HttpEngineError>;
    }
}
