//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/13.
//

import Foundation

// MARK: - PartInfoList
public struct PartInfoList: Codable {
    var etag: String?
    var partSize: Int?
    public let partNumber: Int?
    public var uploadURL: String?

    enum CodingKeys: String, CodingKey {
        case etag
        case partNumber = "part_number"
        case partSize = "part_size"
        case uploadURL = "upload_url"
    }
}
