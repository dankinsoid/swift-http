import Foundation

public extension HttpPipeline {

    func pipeline<T>(_ pipeline: some HttpPipeline<Response, T>) -> some HttpPipeline<Request, T> {
        HttpClosurePipeline { req in
            try await pipeline.execute(with: execute(with: req))
        }
    }

    func map<T>(_ mapper: @escaping (Response) async throws -> T) -> some HttpPipeline<Request, T> {
        HttpClosurePipeline { req in
            try await mapper(execute(with: req))
        }
    }
    
    func pullback<T>(_ mapper: @escaping (T) async throws -> Request) -> some HttpPipeline<T, Response> {
        HttpClosurePipeline { req in
            try await execute(with: mapper(req))
        }
    }

    func chain<Out>(_ chain: (Self) -> Out) -> Out {
        chain(self)
    }

    /// Validates a Response using an array of validators
    func validator(_ validator: some HttpValidator<Response>) -> some HttpPipeline<Request, Response> {
        pipeline(validator)
    }

    /// Validates a Request using an array of validators
    func validator(_ validator: some HttpValidator<Request>) -> some HttpPipeline<Request, Response> {
        HttpClosurePipeline { req in
            try await execute(with: validator.execute(with: req))
        }
    }
}

public extension HttpPipeline where Request == Response {

    /// Validates a HttpResponse using an array of validators
    func validator(_ validator: some HttpValidator<Request>) -> some HttpPipeline<Request, Response> {
        HttpClosurePipeline { req in
            try await validator.execute(with: execute(with: req))
        }
    }
}

public extension HttpPipeline where Request == HttpRequest {

    /// Set header field for all requests
    func header(_ key: HttpHeaderKey, _ value: String) -> some HttpPipeline<Request, Response> {
        HttpClosurePipeline { req in
            try await execute(with: req.header(key, value))
        }
    }
}
public extension HttpPipeline where Response == HttpResponse {

    /// Validates a HttpResponse using an array of validators
    func validateStatusCode(successCode: HttpStatusCode? = nil) -> some HttpPipeline<Request, Response> {
        pipeline(HttpStatusCodeValidator(successCode))
    }
}
