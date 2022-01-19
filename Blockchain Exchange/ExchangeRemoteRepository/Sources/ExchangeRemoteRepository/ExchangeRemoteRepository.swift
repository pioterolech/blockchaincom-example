import Foundation
import Combine

public protocol ExchangeRemoteRepositoryInterface {
    func symbols() -> AnyPublisher<[String: SymbolsHttpEntity], HttpEngineError>
    func prices(symbol: String) -> AnyPublisher<PricesHttpEntity, HttpEngineError>
}

public final class ExchangeRemoteRepository: ExchangeRemoteRepositoryInterface {
    private let engine: HttpEngingeInterface
    private let urlFactory: URLFactory

    public init(engine: HttpEngingeInterface, urlFactory: URLFactory) {
        self.engine = engine
        self.urlFactory = urlFactory
    }

    public func symbols() -> AnyPublisher<[String: SymbolsHttpEntity], HttpEngineError> {
        engine.fetch(with: urlFactory.symbols)
    }

    public func prices(symbol: String) -> AnyPublisher<PricesHttpEntity, HttpEngineError> {
        engine.fetch(with: urlFactory.prices(symbol: symbol))
    }
}
