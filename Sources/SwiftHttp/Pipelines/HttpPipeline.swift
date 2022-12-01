//
//  HttpPipeline.swift
//  SwiftHttp
//
//  Created by Tibor Bodecs on 2022. 03. 10..
//

import Foundation

///
/// Abstract HTTP request pipeline
///
/// A pipeline is a descriptor of a request -> response workflow.
/// It might includes validations date encoding, decoding
///
public protocol HttpPipeline<Request, Response> {
    
    /// generic request type
    associatedtype Request
    /// generic response type
    associatedtype Response

    ///
    /// Executes the pipeline using an executor object
    ///
    /// The executor is usually a HttpClient task function, returning a response
    ///
    /// - Parameter request: The HttpRequest
    /// - Parameter executor: The  executor function to perform the HttpRequest
    ///
    /// - Throws: `HttpError` if something was wrong with the request
    ///
    /// - Returns: The generic Response object
    ///
    func execute(
        with request: Request
    ) async throws -> Response
}

public extension HttpPipeline where Request == Void {
    
    ///
    /// Executes the pipeline using an executor object
    ///
    /// The executor is usually a HttpClient task function, returning a response
    ///
    /// - Parameter executor: The  executor function to perform the HttpRequest
    ///
    /// - Throws: `HttpError` if something was wrong with the request
    ///
    /// - Returns: The generic Response object
    ///
    func execute() async throws -> Response {
        try await execute(with: ())
    }
}

public extension HttpPipeline {
    
    ///
    /// Executes the pipeline using an executor object
    ///
    /// The executor is usually a HttpClient task function, returning a response
    ///
    /// - Parameter executor: The  executor function to perform the HttpRequest
    ///
    /// - Throws: `HttpError` if something was wrong with the request
    ///
    /// - Returns: The generic Response object
    ///
    func execute<T>() async throws -> Response where Request == T? {
        try await execute(with: nil)
    }
}
