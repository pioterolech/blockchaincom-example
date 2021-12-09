import RxSwift
import Foundation

public protocol ExchangeRemoteDataSourceInterface {
    func symbols() -> Observable<[String: SymbolsHttpEntity]>
    func prices(symbol: String) -> Observable<PricesHttpEntity>
}

public final class ExchangeRemoteDataSource: ExchangeRemoteDataSourceInterface {
    private let engine: HttpEngingeInterface
    private let urlFactory: URLFactory

    public init(engine: HttpEngingeInterface, urlFactory: URLFactory) {
        self.engine = engine
        self.urlFactory = urlFactory
    }

    public func symbols() -> Observable<[String: SymbolsHttpEntity]> {
        engine.fetch(with: urlFactory.symbols)
    }

    public func prices(symbol: String) -> Observable<PricesHttpEntity> {
        engine.fetch(with: urlFactory.prices(symbol: symbol))
    }
}
