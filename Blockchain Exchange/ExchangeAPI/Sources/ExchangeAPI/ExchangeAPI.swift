import RxSwift
import Foundation

public class ExchangeAPI {
    private let engine: HttpEngingeInterface
    private let urlFactory: URLFactory

    init(engine: HttpEngingeInterface, urlFactory: URLFactory) {
        self.engine = engine
        self.urlFactory = urlFactory
    }

    func symbols() -> Observable<[String: SymbolsHttpEntity]> {
        engine.fetch(with: urlFactory.symbols)
    }
}
