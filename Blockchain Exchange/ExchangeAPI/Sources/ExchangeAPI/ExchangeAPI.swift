import RxSwift
import Foundation

public protocol ExchangeAPIInterface {
    func symbols() -> Observable<[String: SymbolsHttpEntity]>
}

public final class ExchangeAPI: ExchangeAPIInterface {
    private let engine: HttpEngingeInterface
    private let urlFactory: URLFactory

    public init(engine: HttpEngingeInterface, urlFactory: URLFactory) {
        self.engine = engine
        self.urlFactory = urlFactory
    }

    public func symbols() -> Observable<[String: SymbolsHttpEntity]> {
        engine.fetch(with: urlFactory.symbols)
    }
}
