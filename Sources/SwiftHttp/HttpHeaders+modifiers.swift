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
    
    func authorization(_ value: String) -> [HttpHeaderKey: String] {
        var result = self
        result[.authorization] = value
        return result
    }
}
