//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/15.
//

import Foundation

public struct PDSGetDownloadUrlResponse: PDSModel {
    public let expiration, method: String?
    public let size: Int?
    public let streamsURL: StreamsURL?
    public let url: String?

    enum CodingKeys: String, CodingKey {
        case expiration, method, size
        case streamsURL = "streams_url"
        case url
    }
    
    // MARK: - StreamsURL
    public struct StreamsURL: Codable {
        public let string: String?
    }
}



