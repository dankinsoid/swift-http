//
//  URLResponse+ext.swift
//  SwiftHttp
//
//  Created by Tibor Bodecs on 2022. 01. 02..
//

import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public extension HTTPURLResponse {
    ///
    /// Initialize the response
    ///
    /// - Parameter url: The url of the request
    /// - Parameter statusCode: The status code
    /// - Parameter headers: The header fields
    /// - Parameter data: The body data
    ///
    convenience init(
        url _: URL,
        statusCode: HttpStatusCode,
        headers: [HttpHeaderKey: String],
        data: Data
    ) {
        self.init(
            url: url,
            statusCode: statusCode.rawValue,
            httpVersion: nil,
            headerFields: [String: String]?
        )
        allHeaderFields
        self.statusCode = statusCode.rawValue
        self.headers = headers
        self.data = data
    }

    ///
    /// Initialize the response
    ///
    /// - Parameter tuple: A tuple value with a Data, URLResponse type
    ///
    /// - Throws: `HttpError` if something was wrong with the tuple values
    ///
    init(_ tuple: (Data, URLResponse)) throws {
        guard let response = tuple.1 as? HTTPURLResponse else {
            throw HttpError.invalidResponse
        }
        var headers: [HttpHeaderKey: String] = [:]
        for header in response.allHeaderFields {
            let key = String(describing: header.key)
            let value = String(describing: header.value)
            let headerKey: HttpHeaderKey = .custom(key)
            headers[headerKey] = value
        }
        guard let statusCode = HttpStatusCode(rawValue: response.statusCode)
        else {
            throw HttpError.unknownStatusCode
        }
        self.init(statusCode: statusCode, headers: headers, data: tuple.0)
    }

    /// Converts the response data to a UTF-8 String value
    var utf8String: String? {
        String(data: data, encoding: .utf8)
    }

    var traceLogValue: String {
        let prettyHeaders =
            headers
                .map { "\($0.key.rawValue): \($0.value)" }
                .sorted()
                .joined(separator: "\n")

        return """

        \(prettyHeaders)
        \(statusCode.rawValue)
        """
    }
}
