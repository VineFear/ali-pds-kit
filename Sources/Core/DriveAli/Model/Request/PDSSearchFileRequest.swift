//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/15.
//

import Foundation

public struct PDSSearchFileRequest: Codable {
    let driveID: String
    let query: String
    /*
     ASC代表正序，DESC代表逆序
     语法为 字段名 + 空格 + ASC/DESC
     如果多个字段排序则需要用逗号隔开
     前面的规则优先级高
     */
    let orderBy: String
    
    var imageThumbnailProcess, imageURLProcess: String?
    var limit: Int = 50
    var marker: String?
    var urlExpireSEC: Int?
    var videoThumbnailProcess: String?

    enum CodingKeys: String, CodingKey {
        case driveID = "drive_id"
        case imageThumbnailProcess = "image_thumbnail_process"
        case imageURLProcess = "image_url_process"
        case limit, marker
        case orderBy = "order_by"
        case query
        case urlExpireSEC = "url_expire_sec"
        case videoThumbnailProcess = "video_thumbnail_process"
    }
    
    public init(driveId: String, query: String, orderBy: String = "updated_at DESC") {
        self.driveID = driveId
        self.query = query
        self.orderBy = orderBy
    }
}
