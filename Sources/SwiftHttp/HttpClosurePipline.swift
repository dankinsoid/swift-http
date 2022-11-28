import Foundation

/// A raw pipeline can be used to send an recieve raw body data values
struct HttpClosurePipeline<Request, Response>: HttpRequestPipeline {
    
    private let pipeline: PipelineExecute<Request, Response>
    
    init(_ execute: @escaping PipelineExecute<Request, Response>) {
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
    func execute(
        request: Request,
        _ executor: (HttpRequest) async throws -> HttpResponse
    ) async throws -> Response {
        try await pipeline(request, executor)
    }
}
