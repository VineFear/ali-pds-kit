//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/6.
//

import Foundation

public struct UserInfoModel: PDSModel {
    let domainID, userID: String
    let avatar: String
    let createdAt, updatedAt: Int
    let email, nickName, phone, role: String
    let status, userName, welcomeDescription, defaultDriveID: String
    let userData: UserData

    enum CodingKeys: String, CodingKey {
        case domainID = "domain_id"
        case userID = "user_id"
        case avatar
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case email
        case nickName = "nick_name"
        case phone, role, status
        case userName = "user_name"
        case welcomeDescription = "description"
        case defaultDriveID = "default_drive_id"
        case userData = "user_data"
    }
    
    // MARK: - UserData
    struct UserData: Codable {
        let share: String?
    }
}
