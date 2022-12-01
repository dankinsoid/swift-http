//
//  HttpDecodablePipeline.swift
//  SwiftHttp
//
//  Created by Tibor Bodecs on 2022. 03. 10..
//

import Foundation

public extension HttpPipeline where Response == Data {
    
    /// A decodable pipeline workflow, to decode a value from the response
    func decode<T: Decodable>(
        with decoder: HttpResponseDecoder<T> = .json(),
        errorType: (any Error & Decodable).Type? = nil
    ) -> some HttpPipeline<Request, T> {
        map {
            try decoder.decode($0)
        }
    }
    
    /// A decodable pipeline workflow, to decode a value from the response
    func decode<T: Decodable>(
        _ type: T.Type,
        with decoder: HttpDataDecoder = JSONDecoder(),
        validator: any HttpResponseValidator = .contentJson
    ) -> some HttpPipeline<Request, T> {
        decode(
            with: HttpResponseDecoder(decoder: decoder, validators: validators)
        )
    }
}

public extension HttpPipeline where Response == HttpResponse {
    
    /// A decodable pipeline workflow, to decode a value from the response
    func decode<T: Decodable>(
        with decoder: HttpResponseDecoder<T> = .json()
    ) -> some HttpPipeline<Request, T> {
        map(\.data).decode(with: decoder)
    }
    
    /// A decodable pipeline workflow, to decode a value from the response
    func decode<T: Decodable>(
        _ type: T.Type,
        with decoder: HttpDataDecoder = JSONDecoder(),
        validators: [any HttpResponseValidator] = [.contentJson]
    ) -> some HttpPipeline<Request, T> {
        decode(
            with: HttpResponseDecoder(decoder: decoder, validators: validators)
        )
    }
}
