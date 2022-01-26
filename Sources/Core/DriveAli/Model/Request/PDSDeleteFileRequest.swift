//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/13.
//

import Foundation

// MARK: - PDSDeleteFileRequest
struct PDSDeleteFileRequest: Codable {
    let driveID, fileID: String
    let permanently: Bool

    enum CodingKeys: String, CodingKey {
        case driveID = "drive_id"
        case fileID = "file_id"
        case permanently
    }
    
    init(driveId: String, fileId: String, permanently: Bool) {
        self.driveID = driveId
        self.fileID = fileId
        self.permanently = permanently
    }
}
