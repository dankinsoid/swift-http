import Foundation

struct PipelineHttpClient: HttpClient {
    
    private let client: HttpClient
    private let pipeline: any HttpRequestPipeline<HttpRequest, HttpResponse>
    
    init(client: HttpClient, pipeline: any HttpRequestPipeline<HttpRequest, HttpResponse>) {
        self.client = client
        self.pipeline = pipeline
    }
    
    func dataTask(_ req: HttpRequest) async throws -> HttpResponse {
        try await execute(req, task: client.dataTask)
    }
    
    func downloadTask(_ req: HttpRequest) async throws -> HttpResponse {
        try await execute(req, task: client.downloadTask)
    }
    
    func uploadTask(_ req: HttpRequest) async throws -> HttpResponse {
        try await execute(req, task: client.uploadTask)
    }
    
    private func execute(_ req: HttpRequest, task: (_ req: HttpRequest) async throws -> HttpResponse) async throws -> HttpResponse {
        try await pipeline.execute(with: req, task)
    }
}
