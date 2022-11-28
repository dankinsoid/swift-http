import Foundation

public struct HttpEmptyPipeline: HttpRequestPipeline {
    
    public func execute(with request: HttpRequest, _ executor: (HttpRequest) async throws -> HttpResponse) async throws -> HttpResponse {
        try await executor(request)
    }
}
