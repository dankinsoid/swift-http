//
//  HttpDecodablePipeline.swift
//  SwiftHttp
//
//  Created by Tibor Bodecs on 2022. 03. 10..
//

import Foundation

public extension HttpRequestPipeline where Response == Data {
    
    /// A decodable pipeline workflow, to decode a value from the response
    func decode<T: Decodable>(
        with decoder: HttpResponseDecoder<T> = .json(),
        errorType: (any Error & Decodable).Type? = nil
    ) -> some HttpRequestPipeline<Request, T> {
        map {
            try decoder.decode($0)
        }
    }
    
    /// A decodable pipeline workflow, to decode a value from the response
    func decode<T: Decodable>(
        _ type: T.Type,
        with decoder: HttpDataDecoder = JSONDecoder(),
        validators: [any HttpResponseValidator] = [.contentJson]
    ) -> some HttpRequestPipeline<Request, T> {
        decode(
            with: HttpResponseDecoder(decoder: decoder, validators: validators)
        )
    }
}

public extension HttpRequestPipeline where Response == HttpResponse {
    
    /// A decodable pipeline workflow, to decode a value from the response
    func decode<T: Decodable>(
        with decoder: HttpResponseDecoder<T> = .json()
    ) -> some HttpRequestPipeline<Request, T> {
        map(\.data).decode(with: decoder)
    }
    
    /// A decodable pipeline workflow, to decode a value from the response
    func decode<T: Decodable>(
        _ type: T.Type,
        with decoder: HttpDataDecoder = JSONDecoder(),
        validators: [any HttpResponseValidator] = [.contentJson]
    ) -> some HttpRequestPipeline<Request, T> {
        decode(
            with: HttpResponseDecoder(decoder: decoder, validators: validators)
        )
    }
}
