//
//  HttpResponseDecoder.swift
//  SwiftHttp
//
//  Created by Tibor Bodecs on 2022. 03. 09..
//

import Foundation

/// A response decoder that can transform the body data into a decodable object and validate the response
public struct HttpResponseDecoder<T: Decodable>: HttpResponseTransformer {

    /// The response valdators
    public let validators: [any HttpResponseValidator]
    
    let decoder: HttpDataDecoder

    ///
    /// Initialize a response decoder
    ///
    /// - Parameter decoder: The decoder to use for the decoding
    /// - Parameter validators: The array of validators
    ///
    public init(decoder: HttpDataDecoder, validators: [any HttpResponseValidator] = []) {
        self.decoder = decoder
        self.validators = validators
    }

    ///
    /// Decodes the data using the decoder
    ///
    /// - Parameter data: The  HttpRequest to perfrom
    ///
    /// - Throws: `Error` if something was wrong during the decoding
    ///
    /// - Returns: The decoded object
    ///
    public func decode(_ data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}

public extension HttpResponseDecoder {
    
    ///
    /// Initialize a JSON response decoder
    ///
    /// - Parameter decoder: The JSONDecoder object to use, the default is the built in JSONDecoder
    /// - Parameter validators: The array of validators, by default it validates the content type
    ///
    static func json(
        _ decoder: HttpDataDecoder = JSONDecoder(),
        validators: [any HttpResponseValidator] = [
            HttpHeaderValidator(.contentType) {
                $0.contains("application/json")
            }
    		]
    ) -> HttpResponseDecoder {
        HttpResponseDecoder(decoder: decoder, validators: validators)
    }
}
