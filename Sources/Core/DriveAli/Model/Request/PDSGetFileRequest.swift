//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/15.
//

import Foundation

public struct PDSGetFileRequest: Codable {
    let driveID: String
    let fileID: String
    
    
    var fields: String = "*"
    var imageThumbnailProcess: String?
    var imageURLProcess: String?
    var urlExpireSEC: Int?
    var videoThumbnailProcess: String?
    
    enum CodingKeys: String, CodingKey {
        case driveID = "drive_id"
        case fields
        case fileID = "file_id"
        case imageThumbnailProcess = "image_thumbnail_process"
        case imageURLProcess = "image_url_process"
        case urlExpireSEC = "url_expire_sec"
        case videoThumbnailProcess = "video_thumbnail_process"
    }
    
    public init(driveId: String, fileId: String) {
        self.driveID = driveId
        self.fileID = fileId
    }
}
