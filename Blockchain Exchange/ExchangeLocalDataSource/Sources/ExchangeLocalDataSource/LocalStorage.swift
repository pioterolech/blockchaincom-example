import RxSwift
import Foundation

public protocol ExchangeLocalDataSourceInterface {
    func saveSymbols(symbols: SymbolsDataSourceEntity) -> Observable<SymbolsDataSourceEntity>
    func getSymbols() -> Observable<SymbolsDataSourceEntity>
}

public final class ExchangeLocalDataSource: ExchangeLocalDataSourceInterface {
    private let engine: LocalStorageEngineInterface

    public init(engine: LocalStorageEngineInterface) {
        self.engine = engine
    }

    public func saveSymbols(symbols: SymbolsDataSourceEntity) -> Observable<SymbolsDataSourceEntity> {
        engine.saveData(data: symbols, identifier: "symbolsIndentifier")
    }

    public func getSymbols() -> Observable<SymbolsDataSourceEntity> {
        return engine.getData(identifier: "symbolsIndentifier")
    }
}
