import Foundation

public typealias HttpRequestValidator = HttpValidator<HttpRequest>
public typealias HttpResponseValidator = HttpValidator<HttpResponse>

public protocol HttpValidator<Request>: HttpPipeline where Request == Response {

		override associatedtype Response = Request

		func validate(_ request: Request) async throws
}

extension HttpPipeline where Self: HttpValidator {

	public func execute(
			with request: Request
	) async throws -> Request {
			try await validate(request)
			return request
	}
}
