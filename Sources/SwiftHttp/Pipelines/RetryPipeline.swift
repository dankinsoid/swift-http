import Foundation

public extension HttpPipeline {
    
    func retry(
        count: UInt = 1,
        delay: Double = 0
    ) -> some HttpPipeline<Request, Response> {
        HttpClosurePipeline { request in
            var failure: Error?
            for _ in 0...count {
                do {
                    return try await execute(with: request)
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
