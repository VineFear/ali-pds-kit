//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/15.
//

import Foundation

public struct PDSListUploadedPartRequest: Codable {
    let driveID, fileID: String?
    let limit, partNumberMarker: Int?
    let uploadID: String?

    enum CodingKeys: String, CodingKey {
        case driveID = "drive_id"
        case fileID = "file_id"
        case limit
        case partNumberMarker = "part_number_marker"
        case uploadID = "upload_id"
    }
}
