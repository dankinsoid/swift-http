//
//  File.swift
//  
//
//  Created by Viasz-Kádi Ferenc on 2022. 03. 27..
//

import Foundation
import SwiftHttp

struct ImageApi {

    let client: HttpClient = UrlSessionHttpClient(log: true)
    let apiBaseUrl = HttpUrl(host: "via.placeholder.com")

    func download() async throws -> Data {
        let request = HttpRawRequest(url: apiBaseUrl.path("150"), method: .get)
        let res = try await client.downloadTask(request)
        return res.data
    }
}
