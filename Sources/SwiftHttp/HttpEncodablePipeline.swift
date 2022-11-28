//
//  HttpEncodablePipeline.swift
//  SwiftHttp
//
//  Created by Tibor Bodecs on 2022. 03. 10..
//

import Foundation

/// An encodable pipeline can be used to send an encodable object as a request body
public struct HttpEncodablePipeline<T: Encodable>: HttpRequestPipeline {
    
    let url: HttpUrl
    let method: HttpMethod
    let headers: [HttpHeaderKey: String]
    let encoder: HttpRequestEncoder<T>
    
    ///
    /// Initialize the pipeline
    ///
    /// - Parameter url: The url to send the request
    /// - Parameter method: The request method
    /// - Parameter headers: The request headers
    /// - Parameter validators: The response validators
    /// - Parameter encoder: The encoder used to encode the body value
    ///
    public init(url: HttpUrl,
                method: HttpMethod,
                headers: [HttpHeaderKey: String] = [:],
                encoder: HttpRequestEncoder<T>) {
        self.url = url
        self.method = method
        self.headers = headers
        self.encoder = encoder
    }
    
    ///
    /// Executes  the request, encodes the body, validates the response and decodes the data
    ///
    /// - Parameter request: The request body as an encodable value
    /// - Parameter executor: The  executor function to perform the HttpRequest
    ///
    /// - Throws: `Error` if something was wrong
    ///
    /// - Returns: The HTTP response object
    ///
    public func execute(
        request: T,
        _ executor: (HttpRequest) async throws -> HttpResponse
    ) async throws -> HttpResponse {
        let req = HttpRawRequest(
            url: url,
            method: method,
            headers: headers.merging(encoder.headers) { $1 },
            body: try encoder.encode(request)
        )
        return try await executor(req)
    }
}
