import XCTest
import RxBlocking
@testable import ExchangeAPI

final class ExchangeAPITests: XCTestCase {
    private var sut: ExchangeAPI!

    override func setUp() {
        let engine = HttpEngine(urlSession: URLSession.shared, decoder: .init())
        let urlFactory = URLFactory()
        sut = ExchangeAPI(engine: engine, urlFactory: urlFactory)
    }

    func test_symbolsIntegrationTests() throws {
        let response = try sut.symbols().toBlocking(timeout: 10).first()
        XCTAssertNotNil(response)
    }
}
