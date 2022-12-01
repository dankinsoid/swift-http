//
//  HttpEncodablePipeline.swift
//  SwiftHttp
//
//  Created by Tibor Bodecs on 2022. 03. 10..
//

import Foundation

public extension HttpPipeline where Request == Data {
    
    /// An encodable pipeline can be used to send an encodable object as a request body
    func encode<T: Encodable>(
        with encoder: HttpRequestEncoder<T> = .json()
    ) -> some HttpPipeline<T, Response> {
        pullback {
            try encoder.encode($0)
        }
    }
    
    /// An encodable pipeline can be used to send an encodable object as a request body
    func encode<T: Encodable>(
        _ type: T.Type,
        with encoder: HttpDataEncoder = JSONEncoder(),
        headers: [HttpHeaderKey: String] = [:].acceptJson().contentTypeJson()
    ) -> some HttpPipeline<T, Response> {
        encode(with: HttpRequestEncoder(encoder: encoder, headers: headers))
    }
}

public extension HttpPipeline where Request == Data? {
    
    /// An encodable pipeline can be used to send an encodable object as a request body
    func encode<T: Encodable>(
        with encoder: HttpRequestEncoder<T> = .json()
    ) -> some HttpPipeline<T, Response> {
        pullback {
            try encoder.encode($0)
        }
    }
    
    /// An encodable pipeline can be used to send an encodable object as a request body
    func encode<T: Encodable>(
        _ type: T.Type,
        with encoder: HttpDataEncoder = JSONEncoder(),
        headers: [HttpHeaderKey: String] = [:].acceptJson().contentTypeJson()
    ) -> some HttpPipeline<T, Response> {
        encode(with: HttpRequestEncoder(encoder: encoder, headers: headers))
    }
}
