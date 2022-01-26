//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/15.
//

import Foundation

public struct PDSGetFileByPathRequest: Codable {
    let driveID: String
    let fileID: String
    let filePath: String
    let fields: String?
    let imageThumbnailProcess: String? = nil
    let imageURLProcess: String? = nil
    let urlExpireSEC: Int? = nil
    let videoThumbnailProcess: String? = nil

    enum CodingKeys: String, CodingKey {
        case driveID = "drive_id"
        case fields
        case fileID = "file_id"
        case filePath = "file_path"
        case imageThumbnailProcess = "image_thumbnail_process"
        case imageURLProcess = "image_url_process"
        case urlExpireSEC = "url_expire_sec"
        case videoThumbnailProcess = "video_thumbnail_process"
    }
    
    public
    init(driveId: String, fileID: String, filePath: String, fields: String? = "*") {
        self.driveID = driveId
        self.fileID = fileID
        self.filePath = filePath
        self.fields = fields
        
    }
}
