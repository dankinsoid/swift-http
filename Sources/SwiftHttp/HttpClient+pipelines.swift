import Foundation

public extension HttpClient {
    
    func pipeline(_ pipeline: any HttpRequestPipeline<HttpRequest, HttpResponse>) -> HttpClient {
        PipelineHttpClient(client: self, pipeline: pipeline)
    }
    
    func pipeline(_ execute: @escaping PipelineExecute<HttpRequest, HttpResponse>) -> HttpClient {
        pipeline(HttpClosurePipeline(execute))
    }
    
    /// Validates a HttpResponse using an array of validators
    func validators(_ validators: [any HttpResponseValidator]) -> HttpClient {
        pipeline { req, executor in
            let response = try await executor(req)
            try HttpResponseValidation(validators).validate(response)
            return response
        }
    }
    
    /// Validates a HttpResponse using an array of validators
    func validators(_ validators: any HttpResponseValidator...) -> HttpClient {
        self.validators(validators)
    }
    
    /// Validates a HttpResponse using an array of validators
    func validateStatusCode(successCode: HttpStatusCode? = nil) -> HttpClient {
        validators(HttpStatusCodeValidator(successCode))
    }
    
    
    /// Set header field for all requests
    func header(_ key: HttpHeaderKey, _ value: String) -> HttpClient {
        pipeline { req, executor in
            try await executor(req.header(key, value))
        }
    }
    
    /// Set authorization header field for all requests
    func authorization(_ value: String) -> HttpClient {
        header(.authorization, value)
    }
}
