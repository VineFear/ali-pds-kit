//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/15.
//

import Foundation

public struct PDSGetDownloadUrlRequest: Codable {
    let driveID: String
    let fileID: String
    
    var expireSEC: Int?
    var fileName: String?
    
    enum CodingKeys: String, CodingKey {
        case driveID = "drive_id"
        case expireSEC = "expire_sec"
        case fileID = "file_id"
        case fileName = "file_name"
    }
    
    public init(driveId: String, fileId: String) {
        self.driveID = driveId
        self.fileID = fileId
    }
}
