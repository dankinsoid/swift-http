import Foundation

/// A raw pipeline can be used to send an recieve raw body data values
public struct HttpClosurePipeline<Request, Response>: HttpPipeline {
    
    private let pipeline: (Request) async throws -> Response

    public init(_ execute: @escaping (Request) async throws -> Response) {
        pipeline = execute
    }
    
    ///
    /// Executes  the request, encodes the body, validates the response and decodes the data
    ///
    /// - Parameter request: The HttpRequest
    /// - Parameter executor: The  executor function to perform the HttpRequest
    ///
    /// - Throws: `Error` if something was wrong
    ///
    /// - Returns: The HTTP response object
    ///
    public func execute(
        with request: Request
    ) async throws -> Response {
        try await pipeline(request)
    }
}
