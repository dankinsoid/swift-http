////
////  HttpCodablePipelineCollection.swift
////  SwiftHttp
////
////  Created by Tibor Bodecs on 2022. 03. 10..
////
//
//import Foundation
//
///// A collection of built-in request pipelines, raw, encodable, decodable, codable
//public protocol HttpCodablePipelineCollection {
//
//    ///
//    /// The generic encoder object used to encode body values
//    ///
//    /// - Returns: The generic request encoder instance
//    ///
//    func encoder<T: Encodable>() -> HttpRequestEncoder<T>
//    
//    ///
//    /// The generic decoder object used to decode response data
//    ///
//    /// - Returns: The generic response decoder
//    ///
//    func decoder<T: Decodable>() -> HttpResponseDecoder<T>
//}
//
//public extension HttpCodablePipelineCollection {
//
//    ///
//    /// The generic encoder object used to encode body values
//    ///
//    /// - Returns: The default json encoder
//    ///
//    func encoder<T: Encodable>() -> HttpRequestEncoder<T> { .json() }
//    
//    ///
//    /// The generic decoder object used to decode response data
//    ///
//    /// - Returns: The default json decoder
//    ///
//    func decoder<T: Decodable>() -> HttpResponseDecoder<T> { .json() }
//}
//
//public extension HttpCodablePipelineCollection {
//    
//    ///
//    /// Executes a raw request pipeline using a data values as a body and returns the response
//    ///
//    /// - Parameter executor: The  executor function to perform the HttpRequest
//    /// - Parameter url: The url to send the request
//    /// - Parameter method: The request method
//    /// - Parameter headers: The request headers
//    /// - Parameter body: The request body as a data value
//    /// - Parameter validators: The response validators
//    ///
//    /// - Throws: `Error` if something was wrong
//    ///
//    /// - Returns: The HTTP response object
//    ///
//    func rawRequest(
//        executor: (HttpRequest) async throws -> HttpResponse,
//        url: HttpUrl,
//        method: HttpMethod,
//        headers: [HttpHeaderKey: String] = [:],
//        body: Data? = nil
//    ) async throws -> HttpResponse {
//        try await executor(
//              HttpRawPipeline(
//                url: url,
//                method: method,
//                headers: headers
//            )
//            .execute(with: body)
//        )
//    }
//    
//    ///
//    /// Executes an encodable request pipeline using an encodable object as a body value and returns the response
//    ///
//    /// - Parameter executor: The  executor function to perform the HttpRequest
//    /// - Parameter url: The url to send the request
//    /// - Parameter method: The request method
//    /// - Parameter headers: The request headers
//    /// - Parameter body: The request body as an encodable object
//    /// - Parameter validators: The response validators
//    ///
//    /// - Throws: `Error` if something was wrong
//    ///
//    /// - Returns: The HTTP response object
//    ///
//    func encodableRequest<T: Encodable>(
//        executor: (HttpRequest) async throws -> HttpResponse,
//        url: HttpUrl,
//        method: HttpMethod,
//        headers: [HttpHeaderKey: String] = [:],
//        body: T
//    ) async throws -> HttpResponse {
//        try await HttpRawPipeline(
//            url: url,
//            method: method,
//            headers: headers
//        )
//        .encode(with: encoder())
//        .execute(with: body, executor)
//    }
//    
//    ///
//    /// Executes a raw request pipeline using a data values as a body and returns the response
//    ///
//    /// - Parameter executor: The  executor function to perform the HttpRequest
//    /// - Parameter url: The url to send the request
//    /// - Parameter method: The request method
//    /// - Parameter headers: The request headers
//    /// - Parameter body: The request body as a data value
//    /// - Parameter validators: The response validators
//    ///
//    /// - Throws: `Error` if something was wrong
//    ///
//    /// - Returns: The decoded response object
//    ///
//    func decodableRequest<U: Decodable>(
//        executor: ((HttpRequest) async throws -> HttpResponse),
//        url: HttpUrl,
//        method: HttpMethod,
//        body: Data? = nil,
//        headers: [HttpHeaderKey: String] = [:],
//        validators: [any HttpResponseValidator] = []
//    ) async throws -> U {
//        try await HttpRawPipeline(
//            url: url,
//            method: method,
//            headers: headers
//        )
//        .decode(with: decoder())
//        .validators(validators)
//        .execute(with: body, executor)
//    }
//    
//    ///
//    /// Executes a codable request pipeline using an encodable body and decodes the response
//    ///
//    /// - Parameter executor: The  executor function to perform the HttpRequest
//    /// - Parameter url: The url to send the request
//    /// - Parameter method: The request method
//    /// - Parameter headers: The request headers
//    /// - Parameter body: The request body as an encodable value
//    /// - Parameter validators: The response validators
//    ///
//    /// - Throws: `Error` if something was wrong
//    ///
//    /// - Returns: The decoded response object
//    ///
//    func codableRequest<T: Encodable, U: Decodable>(
//        executor: (HttpRequest) async throws -> HttpResponse,
//        url: HttpUrl,
//        method: HttpMethod,
//        headers: [HttpHeaderKey: String] = [:],
//        body: T
//    ) async throws -> U {
//        try await HttpRawPipeline(
//            url: url,
//            method: method,
//            headers: headers
//        )
//        .encode(with: encoder())
//        .decode(with: decoder())
//        .validators(validators)
//        .execute(with: body, executor)
//    }
//}
