//
//  HttpError.swift
//  SwiftHttp
//
//  Created by Tibor Bodecs on 2022. 01. 02..
//

import Foundation

/// A generic error object to transfer HTTP related error messages
public enum HttpError: LocalizedError {
    /// The response is not a valid HTTP response
    case invalidResponse

    /// The response has a unknown status code
    case unknownStatusCode

    /// The response has an invalid status code
    case invalidStatusCode(URLResponse)

    /// The response is missing a header
    case missingHeader(URLResponse)

    /// The response has an invalid header value
    case invalidHeaderValue(URLResponse)

    /// Upload request does not have data to send
    case missingUploadData

    /// Unknown error
    case unknown(Error)

    /// Proper error descriptions  for the HttpError values
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response"
        case .unknownStatusCode:
            return "Unknown status code"
        case let .invalidStatusCode(response):
            return "Invalid status code: \(response.statusCode.rawValue)"
        case .missingHeader:
            return "Missing header"
        case .invalidHeaderValue:
            return "Invalid header value"
        case .missingUploadData:
            return "Missing upload data"
        case let .unknown(error):
            return error.localizedDescription
        }
    }
}
