import Foundation

public protocol HttpRequestPipelineChain<In, Out> {
    
    associatedtype In: HttpRequestPipeline = HttpRawPipeline
    associatedtype Out: HttpRequestPipeline = In
    func chain(pipeline: In) -> Out
}

public extension HttpRequestPipelineChain where In == Out {
    
    func chain(pipeline: In) -> Out {
        pipeline
    }
}

public struct EmptyPipelineChain: HttpRequestPipelineChain {
    
    public func chain(pipeline: HttpRawPipeline) -> HttpRawPipeline {
        pipeline
    }
}

public protocol API {
}

public struct SpotifyAPI {

    func map<In: Encodable, Out: Codable>(
        pipeline: some HttpRequestPipeline<Data?, HttpResponse>
    ) -> some HttpRequestPipeline {
        pipeline
            .decode(Wrapper<Out>.self)
            .map(\.item)
            .encode(In.self)
            
    }
    
    func use() {
        map(pipeline: HttpEmptyPipeline())
            .execute(<#T##executor: (HttpRequest) async throws -> HttpResponse##(HttpRequest) async throws -> HttpResponse#>)
    }
}

struct Wrapper<T: Codable>: Codable {
    
    var item: T
}

func ttt() {
//
//    try await SpotifyAPI().execute(\.books, with: request)
//
//    SpotifyAPI().books
//        .execute(
//            with: request,
//            executor: client.dataTask
//        )
//
//    HttpRawPipeline(
//        url: <#T##HttpUrl#>,
//        method: <#T##HttpMethod#>,
//        headers: <#T##[HttpHeaderKey : String]#>
//    )
//
//
//    HttpRawRequest(url: HttpUrl(host: ""))
//        .pipeline(
//            HttpEmptyPipeline()
//                .retry()
//                .decode(Response.self)
//                .encode(Request.self)
//                .chain {
//                    $0
//                        .retry()
//                        .header(.authorization, 12)
//                }
//        )
//        .execute(executor: client.dataTask)
}

public protocol HttpRequestPipelineChainable<Request, Response> {
    
    associatedtype Request = HttpRequest
    associatedtype Response = HttpResponse
    associatedtype PipelineChained
    associatedtype InitialPipeline: HttpRequestPipeline<Request, Response> = HttpEmptyPipeline
    
    var initialPipeline: InitialPipeline { get }
    
    func pipeline(
        _ pipeline: some HttpRequestPipeline
    ) -> PipelineChained
}

extension HttpRequestPipelineChainable {
    
    func retry() -> PipelineChained {
        pipeline(
            HttpClosurePipeline<Request, Response> { req, executor in
                try await initialPipeline.execute(with: req, executor)
            }
        )
    }
    
    func map<T>(mapper: @escaping (Response) throws -> T) -> PipelineChained {
        pipeline(
            HttpClosurePipeline<Request, T> { req, executor in
                try await mapper(initialPipeline.execute(with: req, executor))
            }
        )
    }
}

public extension HttpRequestPipelineChainable where Self: HttpClient,
                                                    PipelineChained == HttpClient,
                                                    Request == HttpRequest,
                                                    Response == HttpResponse,
																										InitialPipeline == HttpEmptyPipeline {
    
    var initialPipeline: HttpEmptyPipeline {
        HttpEmptyPipeline()
    }
}

public extension HttpRequestPipelineChainable where Self: HttpClient,
                                                    PipelineChained == HttpClient,
                                             				Request == HttpRequest,
                                             				Response == HttpResponse {
    
    func pipeline(
        _ pipeline: (any HttpRequestPipeline<HttpRequest, HttpResponse>) -> some HttpRequestPipeline<HttpRequest, HttpResponse>
    ) -> HttpClient {
        PipelineHttpClient(client: self, pipeline: pipeline(initialPipeline))
    }
}
