//
//  HttpDecodablePipeline.swift
//  SwiftHttp
//
//  Created by Tibor Bodecs on 2022. 03. 10..
//

import Foundation

/// A decodable pipeline workflow, to decode a value from the response
public struct HttpDecodablePipeline<Response: Decodable>: HttpRequestPipeline {
    
    let decoder: HttpResponseDecoder<Response>
    
    ///
    /// Initialize the pipeline
    ///
    /// - Parameter decoder: The decoder used to decode the response data
    ///
    public init(
    	decoder: HttpResponseDecoder<Response>
    ) {
        self.decoder = decoder
    }
    
    ///
    /// Executes  the request, encodes the body, validates the response and decodes the data
    ///
    /// - Parameter request: The HttpRequest
    /// - Parameter executor: The  executor function to perform the HttpRequest
    ///
    /// - Throws: `Error` if something was wrong
    ///
    /// - Returns: The decoded response object
    ///
    public func execute(
        request: HttpRequest,
        _ executor: (HttpRequest) async throws -> HttpResponse
    ) async throws -> Response {
        let response = try await executor(request)
        return try decoder.decode(response.data)
    }
}

