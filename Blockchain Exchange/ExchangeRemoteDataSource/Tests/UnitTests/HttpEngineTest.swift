//
//  HttpEngineTest.swift
//  ExchangeAPITests
//
//  Created by Piotr Olechnowicz on 03/12/2021.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
import Foundation
@testable import ExchangeRemoteDataSource

class HttpEngineTest: RxTestCase {
    private var sut: HttpEngine!
    private var urlSessionMock: URLSessionMock!
    private var decoder: JSONDecoder = .init()
    private var observer: TestableObserver<TestCodable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        createSUT()
        observer = scheduler.createObserver(TestCodable.self)
    }

    // MARK: - Success

    func test_whenCorrectResponseAndData_thenFetchShouldEmitNextWithDecodedData() throws {
        let testData = "{ \"testValue\": \"test\" }"
        let data = testData.data(using: .utf8)
        stubDataTaskWithCompletion(data: data, response: httpResponseOK)
        let observable: Observable<TestCodable> = sut.fetch(with: validURL)

        observable.bind(to: observer).disposed(by: disposeBag)

        XCTAssertEqual(observer.events, [.next(0, TestCodable(testValue: "test"))])
    }

    // MARK: - Errors

    func test_whenIncorrectURLStringProvided_thenFetchEmitsError() throws {
        let observable: Observable<TestCodable> = sut.fetch(with: incorrectURL)

        observable.bind(to: observer).disposed(by: disposeBag)

        XCTAssertEqual(observer.events, [.error(0, HttpEngineErrors.invalidURL)])
    }

    func test_whenDataTaskCompletionReturnsError_thenFetchObservableEmitsError() throws {
        stubDataTaskWithCompletion(error: TestError.exampleError)
        let observable: Observable<TestCodable> = sut.fetch(with: validURL)

        observable.bind(to: observer).disposed(by: disposeBag)

        XCTAssertEqual(observer.events, [.error(0, TestError.exampleError)])
    }

    func test_whenDataTaskCompletionReturnsNilAsResponse_thenFetchEmitsError() throws {
        stubDataTaskWithCompletion()
        let observable: Observable<TestCodable> = sut.fetch(with: validURL)

        observable.bind(to: observer).disposed(by: disposeBag)

        XCTAssertEqual(observer.events, [.error(0, HttpEngineErrors.invalidResponse)])
    }

    func test_whenDataTaskCompletionReturnsFailedHTTPURLResponse_thenFetchEmitsError() throws {
        stubDataTaskWithCompletion(response: httpResponseCodeResourceNotFound)
        let observable: Observable<TestCodable> = sut.fetch(with: validURL)

        observable.bind(to: observer).disposed(by: disposeBag)

        XCTAssertEqual(observer.events, [.error(0, HttpEngineErrors.clientError)])
    }

    func test_whenDataTaskCompletionReturnsSuccessHttpResponseButNoData_thenFetchEmitsError() throws {
        stubDataTaskWithCompletion(response: httpResponseOK)
        let observable: Observable<TestCodable> = sut.fetch(with: validURL)

        observable.bind(to: observer).disposed(by: disposeBag)

        XCTAssertEqual(observer.events, [.error(0, HttpEngineErrors.emptyResponse)])
    }

    func test_whenDataTaskCompletionReturnsSuccessHttpResponseButDataIsNotDecodable_thenFetchEmitsError() throws {
        stubDataTaskWithCompletion(data: Data(), response: httpResponseOK)
        let observable: Observable<TestCodable> = sut.fetch(with: validURL)

        observable.bind(to: observer).disposed(by: disposeBag)

        XCTAssertEqual(observer.events.count, 1)
        XCTAssertTrue(observer.events[0].value.error is DecodingError)
    }
}

// MARK: - Helpers

extension HttpEngineTest {
    func createSUT() {
        urlSessionMock = .init()
        sut = HttpEngine(urlSession: urlSessionMock, decoder: decoder)
    }

    func stubDataTaskWithCompletion(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        urlSessionMock.stubbedCreateDataTaskResult = URLSessionDataTaskMock()
        urlSessionMock.stubbedCreateDataTaskCompletionHandlerResult = (data, response, error)
    }

    var incorrectURL: String {
        ""
    }

    var validURL: String {
        "https://api.blockchain.com"
    }

    var httpResponseCodeResourceNotFound: HTTPURLResponse? {
        let url = URL(string: validURL)!
        return HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: [:])
    }

    var httpResponseOK: HTTPURLResponse? {
        let url = URL(string: validURL)!
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: [:])
    }

}

private struct TestCodable: Codable, Equatable {
    let testValue: String
}

private enum TestError: Error, Equatable {
    case exampleError
}
