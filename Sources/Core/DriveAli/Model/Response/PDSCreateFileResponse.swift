//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/13.
//

import Foundation

// MARK: - PDSCreateFileResponse
public struct PDSCreateFileResponse: PDSModel {
    public let domainID, driveID, encryptMode: String?
    public let parentFileID : String?
    public let rapidUpload: Bool? // 秒传
    public let streamsUploadInfo: StreamsUploadInfo?
    public let type: String?
    public let fileName: String?
    public let partInfoList: [PartInfoList]?

    public let fileID: String
    public let uploadID: String?

    enum CodingKeys: String, CodingKey {
        case domainID = "domain_id"
        case driveID = "drive_id"
        case encryptMode = "encrypt_mode"
        case fileID = "file_id"
        case fileName = "file_name"
        case parentFileID = "parent_file_id"
        case partInfoList = "part_info_list"
        case rapidUpload = "rapid_upload"
        case streamsUploadInfo = "streams_upload_info"
        case type
        case uploadID = "upload_id"
    }
}

// MARK: - StreamsUploadInfo
public struct StreamsUploadInfo: Codable {
    public let string: String
}

