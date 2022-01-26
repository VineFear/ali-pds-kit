//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/15.
//

import Foundation

public struct PDSSearchFileResponse: PDSModel {
    let items: [Item]?
    let nextMarker: String?

    enum CodingKeys: String, CodingKey {
        case items
        case nextMarker = "next_marker"
    }
    
    // MARK: - Item
    struct Item: Codable {
        let driveID, domainID, fileID, name: String
        let type: String
        let createdAt, updatedAt, fileExtension: String?
        let hidden, starred: Bool
        let status, parentFileID, encryptMode: String

        enum CodingKeys: String, CodingKey {
            case driveID = "drive_id"
            case domainID = "domain_id"
            case fileID = "file_id"
            case name, type
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case fileExtension = "file_extension"
            case hidden, starred, status
            case parentFileID = "parent_file_id"
            case encryptMode = "encrypt_mode"
        }
    }
}
