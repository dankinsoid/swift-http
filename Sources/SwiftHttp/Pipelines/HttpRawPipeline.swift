//
//  HttpRawPipeline.swift
//  SwiftHttp
//
//  Created by Tibor Bodecs on 2022. 03. 10..
//

import Foundation

/// A raw pipeline can be used to send an recieve raw body data values
public struct HttpRawPipeline: HttpPipeline {
    
    public var url: HttpUrl
    public var method: HttpMethod
    public var headers: [HttpHeaderKey: String]
    
    ///
    /// Initialize the pipeline
    ///
    /// - Parameter url: The url to send the request
    /// - Parameter method: The request method
    /// - Parameter headers: The request headers
    /// - Parameter body: The request body as a data value
    ///
    public init(
        url: HttpUrl,
        method: HttpMethod,
        headers: [HttpHeaderKey: String] = [:]
    ) {
        self.url = url
        self.method = method
        self.headers = headers
    }
    
    ///
    /// Executes  the request, encodes the body, validates the response and decodes the data
    ///
    /// - Parameter request: The HttpRequest
    /// - Parameter executor: The  executor function to perform the HttpRequest
    ///
    /// - Throws: `Error` if something was wrong
    ///
    /// - Returns: The HTTP response object
    ///
    public func execute(
        with request: Data?
    ) async throws -> HttpRawRequest {
        HttpRawRequest(
          url: url,
          method: method,
          headers: headers,
          body: request
        )
    }
}
