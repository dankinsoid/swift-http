import Foundation

public extension HttpRequestPipeline {
    
    func retry(
        count: UInt = 1,
        delay: Double = 0
    ) -> some HttpRequestPipeline<Request, Response> {
        HttpClosurePipeline { request, executor in
            var failure: Error?
            for _ in 0...count {
                do {
                    return try await execute(with: request, executor)
                } catch {
                    failure = error
                }
                if delay > 0 {
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            }
            throw failure ?? ZeroRepeat()
        }
    }
}

private struct ZeroRepeat: Error {
}
