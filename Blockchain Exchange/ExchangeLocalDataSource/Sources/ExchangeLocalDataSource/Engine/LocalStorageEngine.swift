//
//  File.swift
//  
//
//  Created by Piotr Olechnowicz on 02/12/2021.
//

import Foundation
import RxSwift

public protocol LocalStorageEngineInterface {
    func saveData<T: Encodable>(data: T, identifier: String) -> Observable<T>
    func getData<T: Codable>(identifier: String) -> Observable<T>
}

public class LocalStorageEngine: LocalStorageEngineInterface {
    private let serialScheduler: SerialDispatchQueueScheduler
    private let fileManager: FileManager
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder

    enum Directory {
        case documents
        case caches
    }

    public init(serialScheduler: SerialDispatchQueueScheduler,
                fileManager: FileManager,
                jsonEncoder: JSONEncoder,
                jsonDecoder: JSONDecoder) {
        self.serialScheduler = serialScheduler
        self.fileManager = fileManager
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }

    public func saveData<T: Encodable>(data: T, identifier: String) -> Observable<T> {

        return Observable.create { [weak self] observer in
            do {
                try self?.store(data, to: .caches, as: identifier)
                observer.onNext(data)
            } catch {
                observer.onError(error)
            }
            return Disposables.create { }
        }.subscribe(on: serialScheduler)
    }

    public func getData<T: Codable>(identifier: String) -> Observable<T> {
        return Observable.create { [weak self] observer in
                if let cache = try? self?.retrieve(identifier, from: .caches, as: T.self) {
                    observer.onNext(cache)
                }

                observer.onError(LocalStorageEngineErrors.noCache)
            return Disposables.create { }
        }.subscribe(on: serialScheduler)

    }

    private func getURL(for directory: Directory) throws -> URL {
        var searchPathDirectory: FileManager.SearchPathDirectory

        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        }

        if let url = fileManager.urls(for: searchPathDirectory, in: .userDomainMask).first {
            return url
        } else {
            throw LocalStorageEngineErrors.incorrectCacheDirectory
        }
    }

    private func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: String) throws {
        let url = try getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        let data = try jsonEncoder.encode(object)
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
        fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
    }

    private func retrieve<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) throws -> T {
        let url = try getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)

        if !fileManager.fileExists(atPath: url.path) {
            throw LocalStorageEngineErrors.noCache
        }

        if let data = fileManager.contents(atPath: url.path) {
            return try jsonDecoder.decode(type, from: data)
        } else {
            throw LocalStorageEngineErrors.unableToDecode
        }
    }
}
