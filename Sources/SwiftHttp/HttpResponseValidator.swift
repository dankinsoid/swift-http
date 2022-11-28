//
//  HttpResponseValidator.swift
//  SwiftHttp
//
//  Created by Tibor Bodecs on 2022. 03. 09..
//

import Foundation

/// A generic response validator protocol
public protocol HttpResponseValidator: HttpRequestPipeline<HttpRequest, HttpResponse> {
    
    ///
    /// Validates a response object
    ///
    /// - Parameter response: The HTTP response
    ///
    /// - Throws: `Error` if something was wrong with the response
    ///
    func validate(_ response: HttpResponse) throws
}

extension HttpRequestPipeline where Self: HttpResponseValidator {
    
    public func execute(
        request: HttpRequest,
        _ executor: ((HttpRequest) async throws -> HttpResponse)
    ) async throws -> Response {
        let response = try await executor(request)
        try validate(response)
        return response
    }
}
