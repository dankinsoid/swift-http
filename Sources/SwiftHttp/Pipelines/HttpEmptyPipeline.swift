import Foundation

public struct HttpEmptyPipeline<Request>: HttpPipeline {
    
    public func execute(with request: Request) async throws -> Request {
        request
    }
}
