import Foundation

struct PipelineHttpClient: HttpClient {
    
    private let client: HttpClient
    private let requestPipeline: any HttpPipeline<HttpRequest, HttpRequest>
    private let responsePipeline: any HttpPipeline<HttpResponse, HttpResponse>

    init(
      client: HttpClient,
      requestPipeline: any HttpPipeline<HttpRequest, HttpRequest> = HttpEmptyPipeline(),
      responsePipeline: any HttpPipeline<HttpResponse, HttpResponse> = HttpEmptyPipeline()
    ) {
        self.client = client
        self.requestPipeline = requestPipeline
        self.responsePipeline = responsePipeline
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
        try await responsePipeline.execute(with: task(requestPipeline.execute(with: req)))
    }
}
