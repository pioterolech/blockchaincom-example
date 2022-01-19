//
//  HttpEngineTest.swift
//  ExchangeAPITests
//
//  Created by Piotr Olechnowicz on 03/12/2021.
//

import XCTest
import Foundation
import Combine
@testable import ExchangeRemoteRepository

class HttpEngineTest: XCTestCase {
    private var sut: HttpEngine!
    private var urlSessionMock: URLSessionMock!
    private var decoder: JSONDecoder = .init()

    override func setUpWithError() throws {
        try super.setUpWithError()
        createSUT()
    }

    // MARK: - Success

    func test_whenCorrectResponseAndData_thenFetchShouldEmitNextWithDecodedData() throws {
        stubDataTaskWithCompletion(data: testResponseData, response: httpResponseOK)
        let observable: AnyPublisher<TestCodable, HttpEngineError> = sut.fetch(with: validURL)

        let spy = ValueSpy(observable)

        XCTAssertEqual(spy.values, [TestCodable(testValue: "test")])
    }

    // MARK: - Errors

    func test_whenIncorrectURLStringProvided_thenFetchEmitsError() throws {
        let observable: AnyPublisher<TestCodable, HttpEngineError> = sut.fetch(with: incorrectURL)

        let spy = ValueSpy(observable)

        let context = HttpEngineError.Context.init(reason: "Unable to create URL object from string: " + incorrectURL)
        let expectedError = HttpEngineError.invalidURL(context: context)
        XCTAssertEqual(spy.values, [])
        XCTAssertCompletion(completion: spy.completion, error: expectedError)
    }

    func test_whenDataTaskCompletionReturnsError_thenFetchObservableEmitsError() throws {
        stubDataTaskWithError(error: URLError(.cannotFindHost))
        let observable: AnyPublisher<TestCodable, HttpEngineError> = sut.fetch(with: validURL)

        let spy = ValueSpy(observable)

        let expectedError = HttpEngineError.session(context: .init(reason: "Session error, unable to load url: "))
        XCTAssertCompletion(completion: spy.completion, error: expectedError)
    }

    func test_whenDataTaskCompletionReturnsFailedHTTPURLResponse_thenFetchEmitsError() throws {
        stubDataTaskWithCompletion(data: Data(), response: httpResponseCodeResourceNotFound)
        let observable: AnyPublisher<TestCodable, HttpEngineError> = sut.fetch(with: validURL)

        let spy = ValueSpy(observable)

        let expectedError = HttpEngineError.client(context: .init(reason: "HTTP client error", code: 404))
        XCTAssertCompletion(completion: spy.completion, error: expectedError)
    }

    func test_whenDataTaskCompletionReturnsSuccessHttpResponseButNoData_thenFetchEmitsUnableToDecodeData() throws {
        stubDataTaskWithCompletion(data: Data(), response: httpResponseOK)
        let observable: AnyPublisher<TestCodable, HttpEngineError> = sut.fetch(with: validURL)

        let spy = ValueSpy(observable)

        let expectedReason = "Data corrupted. The given data was not valid JSON. Unable to parse empty data."
        let expectedError = HttpEngineError.decoding(context: .init(reason: expectedReason))
        XCTAssertCompletion(completion: spy.completion, error: expectedError)
    }
 }

// MARK: - Helpers

extension HttpEngineTest {
    func createSUT() {
        urlSessionMock = .init()
        sut = HttpEngine(urlSession: urlSessionMock, decoder: decoder)
    }

    func stubDataTaskWithCompletion(data: Data, response: URLResponse) {
        urlSessionMock.stubbedFetchResult = Result<(data: Data, response: URLResponse), URLError>
            .success((data: data, response: response))
            .publisher
            .eraseToAnyPublisher()
    }

    func stubDataTaskWithError(error: URLError) {
        urlSessionMock.stubbedFetchResult = Result<(data: Data, response: URLResponse), URLError>
            .failure(error)
            .publisher
            .eraseToAnyPublisher()
    }

    var incorrectURL: String {
        "incorrect      url"
    }

    var validURL: String {
        "https://api.blockchain.com"
    }

    var testJSON: String {
        "{ \"testValue\": \"test\" }"
    }

    var testResponseData: Data {
        testJSON.data(using: .utf8)!
    }

    var httpResponseCodeResourceNotFound: HTTPURLResponse {
        let url = URL(string: validURL)!
        return HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: [:])!
    }

    var httpResponseOK: HTTPURLResponse {
        let url = URL(string: validURL)!
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: [:])!
    }
}

private struct TestCodable: Codable, Equatable {
    let testValue: String
}
