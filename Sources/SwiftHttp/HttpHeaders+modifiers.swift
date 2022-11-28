import Foundation

public extension [HttpHeaderKey: String] {
    
    func acceptJson() -> [HttpHeaderKey: String] {
        var result = self
        result[.accept] = "application/json"
        return result
    }
    
    func contentTypeJson() -> [HttpHeaderKey: String] {
        var result = self
        result[.contentType] = "application/json"
        return result
    }
}
