//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/13.
//

import Foundation

public struct PDSDeleteFileResponse: PDSModel {
    let asyncTaskID, domainID, driveID, fileID: String

    enum CodingKeys: String, CodingKey {
        case asyncTaskID = "async_task_id"
        case domainID = "domain_id"
        case driveID = "drive_id"
        case fileID = "file_id"
    }
}
