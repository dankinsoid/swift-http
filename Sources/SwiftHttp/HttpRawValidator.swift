import Foundation

public typealias HttpRawRequestValidator = HttpRawValidator<HttpRequest>
public typealias HttpRawResponseValidator = HttpRawValidator<HttpResponse>

public struct HttpRawValidator<Request>: HttpValidator {

		private let validate: (Request) async throws -> Void

		public init(_ validate: @escaping (Request) async throws -> Void) {
				self.validate = validate
		}

		public func validate(_ response: Request) async throws {
				try await validate(response)
		}
}
