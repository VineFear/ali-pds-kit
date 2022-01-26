//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/14.
//

import Foundation

struct PDSGetUploadUrlRequest: Codable {
    var driveID: String?
    var contentMd5: String?
    
    let partInfoList: [PartInfoList]
    let uploadID, fileID: String

    enum CodingKeys: String, CodingKey {
        case contentMd5 = "content_md5"
        case driveID = "drive_id"
        case partInfoList = "part_info_list"
        case uploadID = "upload_id"
        case fileID = "file_id"
    }
    
    init(driveId: String, fileId: String, uploadId: String, partInfoList: [PartInfoList]) {
        self.driveID = driveId
        self.uploadID = uploadId
        self.fileID = fileId
        self.partInfoList = partInfoList
    }
}
