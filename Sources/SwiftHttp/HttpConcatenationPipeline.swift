import Foundation

public struct HttpConcatenationPipeline<Input: HttpRequestPipeline, Output: HttpRequestPipeline>: HttpRequestPipeline {
    
    public var input: Input
    public var output: Output
    private let map: (Input.Response) async throws -> Output.Request
    
    public init(
        input: Input,
        output: Output,
        map: @escaping (Input.Response) async throws -> Output.Request
    ) {
        self.input = input
        self.output = output
        self.map = map
    }
    
    public func execute(
        request: Input.Request,
        _ executor: (HttpRequest) async throws -> HttpResponse
    ) async throws -> Output.Response {
        let inputResponse = try await input.execute(request: request, executor)
        let outputRequest = try await map(inputResponse)
        return try await output.execute(request: outputRequest, executor)
    }
}

extension HttpConcatenationPipeline where Input.Response == Output.Request {
    
    public init(
    	input: Input,
    	output: Output
    ) {
        self.init(input: input, output: output) {
            $0
        }
    }
}

extension HttpRequestPipeline {
    
    public func concat<T>(_ pipeline: some HttpRequestPipeline<Response, T>) -> some HttpRequestPipeline<Request, T> {
        HttpConcatenationPipeline(input: self, output: pipeline)
    }
    
    public func concat<T: HttpRequestPipeline>(
        _ pipeline: T,
        map: @escaping (Response) async throws -> T.Request
    ) -> some HttpRequestPipeline<Request, T.Response> {
        HttpConcatenationPipeline(input: self, output: pipeline, map: map)
    }
}
