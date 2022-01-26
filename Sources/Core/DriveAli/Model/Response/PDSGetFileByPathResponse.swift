//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/15.
//

import Foundation

// MARK: - PDSGetFileByPathResponse
public struct PDSGetFileByPathResponse: PDSModel {
    let category, contentHash, contentHashName, contentType: String?
    let crc64Hash, createdAt, pdsGetFileByPathResponseDescription, domainID: String?
    let downloadURL: String?
    let driveID, encryptMode, fileExtension, fileID: String?
    let hidden: Bool?
    let imageMediaMetadata: ImageMediaMetadata?
    let labels: [String]?
    let meta, name, parentFileID: String?
    let size: Int?
    let starred: Bool?
    let status: String?
    let streamsURLInfo: StreamsURLInfo?
    let thumbnail: String?
    let trashedAt, type, updatedAt, uploadID: String?
    let url: String?
    let userMeta: String?
    let videoMediaMetadata: VideoMediaMetadata?

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
    struct ImageMediaMetadata: Codable {
        let addressLine, city, country, district: String?
        let exif, faces: String?
        let height: Int?
        let location, province, time, township: String?
        let width: Int?

        enum CodingKeys: String, CodingKey {
            case addressLine = "address_line"
            case city, country, district, exif, faces, height, location, province, time, township, width
        }
    }

    // MARK: - StreamsURLInfo
    struct StreamsURLInfo: Codable {
        let string: String?
    }

    // MARK: - VideoMediaMetadata
    struct VideoMediaMetadata: Codable {
        let addressLine, city, country, district: String?
        let duration, location, province, time: String?
        let township: String?

        enum CodingKeys: String, CodingKey {
            case addressLine = "address_line"
            case city, country, district, duration, location, province, time, township
        }
    }
}


