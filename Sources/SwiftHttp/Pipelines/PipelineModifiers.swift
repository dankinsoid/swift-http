import Foundation

public extension HttpRequestPipeline {
    
    func map<T>(_ mapper: @escaping (Response) async throws -> T) -> some HttpRequestPipeline<Request, T> {
        HttpClosurePipeline { req, executor in
            try await mapper(execute(with: req, executor))
        }
    }
    
    func pullback<T>(_ mapper: @escaping (T) async throws -> Request) -> some HttpRequestPipeline<T, Response> {
        HttpClosurePipeline { req, executor in
            try await execute(with: mapper(req), executor)
        }
    }
    
    func mapRequest<T>(_ mapper: @escaping (inout HttpRequest) async throws -> Void) -> some HttpRequestPipeline<Request, Response> {
        HttpClosurePipeline { req, executor in
            try await execute(with: req) {
                var request = $0
                try await mapper(&request)
                return try await executor(request)
            }
        }
    }
    
    /// Set header field for all requests
    func header(_ key: HttpHeaderKey, _ value: String) -> some HttpRequestPipeline<Request, Response> {
        HttpClosurePipeline { req, executor in
            try await execute(with: req) {
                try await executor($0.header(key, value))
            }
        }
    }
    
    /// Validates a HttpResponse using an array of validators
    func validators(_ validators: [any HttpResponseValidator]) -> some HttpRequestPipeline<Request, Response> {
        HttpClosurePipeline { req, executor in
            let response = try await execute(with: req) {
                let response = try await executor($0)
                try HttpResponseValidation(validators).validate(response)
                return response
            }
            return response
        }
    }
    
    /// Validates a HttpResponse using an array of validators
    func validators(_ validators: any HttpResponseValidator...) -> some HttpRequestPipeline<Request, Response> {
        self.validators(validators)
    }
    
    /// Validates a HttpResponse using an array of validators
    func validateStatusCode(successCode: HttpStatusCode? = nil) -> some HttpRequestPipeline<Request, Response> {
        validators(HttpStatusCodeValidator(successCode))
    }
    
    func chain<Out>(_ chain: (Self) -> Out) -> Out {
        chain(self)
    }
    
    
    func chain<Chain: HttpRequestPipelineChain>(_ chain: Chain) -> Chain.Out where Chain.In == Self  {
        chain.chain(pipeline: self)
    }
}
