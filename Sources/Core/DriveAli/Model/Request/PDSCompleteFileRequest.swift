//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/13.
//

import Foundation

// MARK: - PDSCompleteFileRequest
public struct PDSCompleteFileRequest: Codable {
    var partInfoList: [PartInfoList]?
    
    let uploadID: String
    let driveID: String
    let fileID: String

    enum CodingKeys: String, CodingKey {
        case driveID = "drive_id"
        case partInfoList = "part_info_list"
        case uploadID = "upload_id"
        case fileID = "file_id"
    }
}

