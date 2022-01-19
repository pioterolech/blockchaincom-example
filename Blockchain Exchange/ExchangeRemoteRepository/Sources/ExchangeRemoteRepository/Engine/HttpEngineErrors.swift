//
//  File.swift
//  
//
//  Created by Piotr Olechnowicz on 02/12/2021.
//

import Foundation

public enum HttpEngineError: LocalizedError, Equatable {
    public struct Context: Error, Equatable {
        let reason: String
    }

    public struct ResponseContext: LocalizedError, Equatable {
        let reason: String
        let code: Int
    }

    case invalidResponse
    case invalidURL(context: Context)
    case session(context: Context)
    case client(context: ResponseContext)
    case server(context: ResponseContext)
    case redirect(context: ResponseContext)
    case decoding(context: Context)
    case unknown(context: Context)

    static func invalidURL(_ urlString: String) -> HttpEngineError {
        let context = Context(reason: "Unable to create URL object from string: " + urlString)

        return HttpEngineError.invalidURL(context: context)
    }

    static func error(for responseCode: Int) -> HttpEngineError {
        switch responseCode {
        case 300..<400:
            return .redirect(context: .init(reason: "HTTP redirect", code: responseCode))
        case 400..<500:
            return .client(context: .init(reason: "HTTP client error", code: responseCode))
        case 500..<600:
            return .server(context: .init(reason: "HTTP server error", code: responseCode))
        default:
            return .unknown(context: .init(reason: "Unsupported HTTP code \(responseCode)."))
        }
    }

    static func error(for urlError: URLError) -> HttpEngineError {
        switch urlError.code {
        default:
            let failureString = "Session error, unable to load url: \(urlError.failureURLString ?? "")"
            return .session(context: .init(reason: failureString))
        }
    }

    static func error(for decodingError: DecodingError) -> HttpEngineError {
        switch decodingError {
        case .typeMismatch(_, let context):
            let reason = "Type mismatch. \(context.debugDescription), at: \(context.prettyPath())"
            return .decoding(context: .init(reason: reason))
        case .valueNotFound(_, let context):
            let reason = "Value not found. -> \(context.prettyPath()) <- \(context.debugDescription)"
            return .decoding(context: .init(reason: reason))
        case .keyNotFound(let key, let context):
            let reason = "Key not found. Expected -> \(key.stringValue) <- at: \(context.prettyPath())"
            return .decoding(context: .init(reason: reason))
        case .dataCorrupted(let context):
            let debugDescription = (context.underlyingError as NSError?)?.userInfo["NSDebugDescription"] ?? ""
            let reason = "Data corrupted. \(context.debugDescription) \(debugDescription)"
            return .decoding(context: .init(reason: reason))
        @unknown default:
            return .decoding(context: .init(reason: "Unhandled decoding error"))
        }
    }

    static func enigneError(_ error: Error) -> HttpEngineError {
        if let engineError = error as? HttpEngineError {
            return engineError
        }

        if let urlError = error as? URLError {
            return HttpEngineError.error(for: urlError)
        }

        if let decodingError = error as? DecodingError {
            return HttpEngineError.error(for: decodingError)
        }

        return .unknown(context: .init(reason: error.localizedDescription))
    }
}

private extension DecodingError.Context {
    func prettyPath(separatedBy separator: String = ".") -> String {
        codingPath.map { $0.stringValue }.joined(separator: ".")
    }
}
