//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/15.
//

import Foundation

// MARK: - PDSGetFileByPathResponse
public struct PDSGetFileByPathResponse: PDSModel {
    public let category, contentHash, contentHashName, contentType: String?
    public let crc64Hash, createdAt, pdsGetFileByPathResponseDescription, domainID: String?
    public let downloadURL: String?
    public let driveID, encryptMode, fileExtension, fileID: String?
    public let hidden: Bool?
    public let imageMediaMetadata: ImageMediaMetadata?
    public let labels: [String]?
    public let meta, name, parentFileID: String?
    public let size: Int?
    public let starred: Bool?
    public let status: String?
    public let streamsURLInfo: StreamsURLInfo?
    public let thumbnail: String?
    public let trashedAt, type, updatedAt, uploadID: String?
    public let url: String?
    public let userMeta: String?
    public let videoMediaMetadata: VideoMediaMetadata?

    enum CodingKeys: String, CodingKey {
        case category
        case contentHash = "content_hash"
        case contentHashName = "content_hash_name"
        case contentType = "content_type"
        case crc64Hash = "crc64_hash"
        case createdAt = "created_at"
        case pdsGetFileByPathResponseDescription = "description"
        case domainID = "domain_id"
        case downloadURL = "download_url"
        case driveID = "drive_id"
        case encryptMode = "encrypt_mode"
        case fileExtension = "file_extension"
        case fileID = "file_id"
        case hidden
        case imageMediaMetadata = "image_media_metadata"
        case labels, meta, name
        case parentFileID = "parent_file_id"
        case size, starred, status
        case streamsURLInfo = "streams_url_info"
        case thumbnail
        case trashedAt = "trashed_at"
        case type
        case updatedAt = "updated_at"
        case uploadID = "upload_id"
        case url
        case userMeta = "user_meta"
        case videoMediaMetadata = "video_media_metadata"
    }
    
    // MARK: - ImageMediaMetadata
    public struct ImageMediaMetadata: Codable {
        public let addressLine, city, country, district: String?
        public let exif, faces: String?
        public let height: Int?
        public let location, province, time, township: String?
        public let width: Int?

        enum CodingKeys: String, CodingKey {
            case addressLine = "address_line"
            case city, country, district, exif, faces, height, location, province, time, township, width
        }
    }

    // MARK: - StreamsURLInfo
    public struct StreamsURLInfo: Codable {
        public let string: String?
    }

    // MARK: - VideoMediaMetadata
    public struct VideoMediaMetadata: Codable {
        public let addressLine, city, country, district: String?
        public let duration, location, province, time: String?
        public let township: String?

        enum CodingKeys: String, CodingKey {
            case addressLine = "address_line"
            case city, country, district, duration, location, province, time, township
        }
    }
}


