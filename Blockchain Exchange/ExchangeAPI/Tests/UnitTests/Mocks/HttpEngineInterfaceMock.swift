import RxSwift
@testable import ExchangeAPI

class HttpEngineMock: HttpEngingeInterface {

    var invokedFetch = false
    var invokedFetchCount = 0
    var invokedFetchParameters: (url: String, Void)?
    var invokedFetchParametersList = [(url: String, Void)]()
    var stubbedFetchResult: Observable<Any>!

    func fetch<T: Codable>(with url: String) -> Observable<T> {
        invokedFetch = true
        invokedFetchCount += 1
        invokedFetchParameters = (url, ())
        invokedFetchParametersList.append((url, ()))
        return stubbedFetchResult as! Observable<T>
    }
}
