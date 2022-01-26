//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/13.
//

import Foundation

// MARK: - PDSCreateFileRequest
public struct PDSCreateFileRequest: Codable {
    let name: String
    let type: String
    let checkNameMode: String
    let driveID: String
    let parentFileID: String
    
    let contentMd5: String? = nil
    var contentType: String?
    var partInfoList: [PartInfoList]?
    var size: Int?
    let autoRename: Bool? = nil
    var contentHash: String?
    var contentHashName: String?
    let pdsCreateFileRequestDescription: String? = nil
    let encryptMode: String? = nil
    let fileID: String? = nil
    let hidden: Bool? = nil
    let labels: [String]? = nil
    let lastUpdatedAt: String? = nil
    let meta: String? = nil
    let preHash: String? = nil
    let streamsInfo: StreamsInfo? = nil
    let userMeta: String? = nil

    enum CodingKeys: String, CodingKey {
        case contentMd5 = "content_md5"
        case contentType = "content_type"
        case name
        case partInfoList = "part_info_list"
        case size, type
        case autoRename = "auto_rename"
        case checkNameMode = "check_name_mode"
        case contentHash = "content_hash"
        case contentHashName = "content_hash_name"
        case pdsCreateFileRequestDescription = "description"
        case driveID = "drive_id"
        case encryptMode = "encrypt_mode"
        case fileID = "file_id"
        case hidden, labels
        case lastUpdatedAt = "last_updated_at"
        case meta
        case parentFileID = "parent_file_id"
        case preHash = "pre_hash"
        case streamsInfo = "streams_info"
        case userMeta = "user_meta"
    }
    
    /// 创建文件夹
    /// - Parameters:
    ///   - driveId: 根据用户信息获取
    ///   - parentFileId: 父文件ID 默认 root
    ///   - name: 名字
    ///   - type: 类型
    ///   - check_name_mode:
    init(driveId: String, parentFileId: String, name: String, checkNameMode: String = "refuse") {
        self.driveID = driveId
        self.parentFileID = parentFileId
        self.name = name
        self.type = "folder"
        self.checkNameMode = checkNameMode
    }
    
    init(driveId: String,
         parentFileId: String,
         name: String,
         size: Int,
         contentHash: String,
         partInfoList: [PartInfoList],
         contentHashName: String = "sha1",
         contentType: String? = "application/octet-stream",
         checkNameMode: String = "auto_rename") {
        self.driveID = driveId
        self.parentFileID = parentFileId
        self.name = name
        self.type = "file"
        self.size = size
        self.contentType = contentType
        self.contentHash = contentHash
        self.contentHashName = contentHashName
        self.partInfoList = partInfoList
        
        self.checkNameMode = checkNameMode
    }
}

// MARK: - StreamsInfo
struct StreamsInfo: Codable {
    let string: String
}
