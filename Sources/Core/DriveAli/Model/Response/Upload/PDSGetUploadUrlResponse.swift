//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/14.
//

import Foundation

public struct PDSGetUploadUrlResponse: PDSModel {
    public let createAt, domainID, driveID: String
    public let uploadID: String
    public let fileID: String
    public let partInfoList: [PartInfoList]

    enum CodingKeys: String, CodingKey {
        case createAt = "create_at"
        case domainID = "domain_id"
        case driveID = "drive_id"
        case fileID = "file_id"
        case partInfoList = "part_info_list"
        case uploadID = "upload_id"
    }
}
