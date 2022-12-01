import Foundation

public extension HttpClient {
    
    func pipeline(_ pipeline: some HttpPipeline<HttpRequest, HttpRequest>) -> some HttpClient {
        PipelineHttpClient(client: self, requestPipeline: pipeline)
    }

    func pipeline(_ pipeline: some HttpPipeline<HttpResponse, HttpResponse>) -> some HttpClient {
        PipelineHttpClient(client: self, responsePipeline: pipeline)
    }

    func requestPipeline(_ execute: @escaping (HttpRequest) async throws -> HttpRequest) -> some HttpClient {
        pipeline(
            HttpClosurePipeline { req in
                try await execute(req)
            }
        )
    }

    func responsePipeline(_ execute: @escaping (inout HttpResponse) async throws -> Void) -> some HttpClient {
        pipeline(
          HttpClosurePipeline { req in
              var req = req
              try await execute(&req)
              return req
          }
        )
    }
    
    /// Validates a HttpResponse using an array of validators
    func validateStatusCode(successCode: HttpStatusCode? = nil) -> HttpClient {
        pipeline(HttpStatusCodeValidator(successCode))
    }
    
    
    /// Set header field for all requests
    func header(_ key: HttpHeaderKey, _ value: String) -> HttpClient {
        requestPipeline { req in
            req.header(key, value)
        }
    }
    
    /// Set authorization header field for all requests
    func authorization(_ value: String) -> HttpClient {
        header(.authorization, value)
    }
}
