//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/14.
//

import Foundation

// MARK: - PDSCompleteFileResponse
public struct PDSCompleteFileResponse: PDSModel {
    public let driveID: String
    public let fileID: String
    public let category, contentHash, contentHashName, contentType: String?
    public let crc64Hash, createdAt, pdsCompleteFileResponseDescription, domainID: String?
    public let downloadURL: String? = nil
    public let encryptMode: String? = nil
    public let fileExtension: String? = nil
    public let hidden: Bool? = nil
    public let imageMediaMetadata: ImageMediaMetadata? = nil
    public let labels: [String]? = nil
    public let meta: String? = nil
    public let name: String? = nil
    public let parentFileID: String? = nil
    public let size: Int? = nil
    public let starred: Bool? = nil
    public let status: String? = nil
    public let streamsURLInfo: StreamsURLInfo? = nil
    public let thumbnail: String? = nil
    public let trashedAt, type, updatedAt, uploadID: String?
    public let url: String? = nil
    public let userMeta: String? = nil
    public let videoMediaMetadata: VideoMediaMetadata? = nil
    
    enum CodingKeys: String, CodingKey {
        case category
        case contentHash = "content_hash"
        case contentHashName = "content_hash_name"
        case contentType = "content_type"
        case crc64Hash = "crc64_hash"
        case createdAt = "created_at"
        case pdsCompleteFileResponseDescription = "description"
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
    
    init(driveID: String,
         fileID: String,
         category: String? = nil,
         contentHash: String? = nil,
         contentHashName: String? = nil,
         contentType: String? = nil,
         crc64Hash: String? = nil,
         createdAt: String? = nil,
         pdsCompleteFileResponseDescription: String? = nil,
         domainID: String? = nil,
         trashedAt: String? = nil,
         type: String? = nil,
         updatedAt: String? = nil,
         uploadID: String? = nil
    ) {
        self.driveID = driveID
        self.fileID = fileID
        self.category = category
        self.contentType = contentType
        self.contentHash = contentHash
        self.contentHashName = contentHashName
        self.crc64Hash = crc64Hash
        self.createdAt = createdAt
        self.pdsCompleteFileResponseDescription = pdsCompleteFileResponseDescription
        self.domainID = domainID
        self.trashedAt = trashedAt
        self.type = type
        self.updatedAt = updatedAt
        self.uploadID = uploadID
    }
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
