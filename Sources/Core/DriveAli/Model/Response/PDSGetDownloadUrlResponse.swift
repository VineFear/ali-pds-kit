//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/15.
//

import Foundation

public struct PDSGetDownloadUrlResponse: PDSModel {
    let expiration, method: String?
    let size: Int?
    let streamsURL: StreamsURL?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case expiration, method, size
        case streamsURL = "streams_url"
        case url
    }
    
    // MARK: - StreamsURL
    struct StreamsURL: Codable {
        let string: String?
    }
}



