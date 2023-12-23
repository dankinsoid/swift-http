//
//  URLRequest+ext.swift
//  SwiftHttp
//
//  Created by Tibor Bodecs on 2022. 01. 02..
//

import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public extension URLRequest {
    ///
    /// Initialize the request
    ///
    /// - Parameter url: The url to send the request
    /// - Parameter method: The request method
    /// - Parameter headers: The request headers
    /// - Parameter body: The request body as a data value
    ///
    init(
        url: URL,
        method: HttpMethod = .get,
        headers: [HttpHeaderKey: String] = [:],
        body: Data? = nil
    ) {
        self.init(url: url)
        httpMethod = method.rawValue.uppercased()
        httpBody = body
        for (key, value) in headers {
            addValue(value, forHTTPHeaderField: key.rawValue)
        }
    }

    ///
    /// Change the method of the request
    ///
    /// - Parameter method: The new method value
    ///
    /// - Returns: A new request object with the updated method
    ///
    func method(_ method: HttpMethod) -> URLRequest {
        var result = self
        result.httpMethod = method.rawValue.uppercased()
        return result
    }

    ///
    /// Add a new header value to the request
    ///
    /// - Parameter key: The query values
    /// - Parameter value: The query values
    ///
    /// - Returns: A new request object with the updated headers
    ///
    func header(_ key: HttpHeaderKey, _ value: String) -> URLRequest {
        var result = self
        result.addValue(value, forHTTPHeaderField: key.rawValue)
        return result
    }

    ///
    /// Set a new body value for the request
    ///
    /// - Parameter body: The raw data value for the body
    ///
    /// - Returns: A new request object with the updated body value
    ///
    func body(_ body: Data) -> URLRequest {
        var result = self
        result.httpBody = body
        return result
    }
}
