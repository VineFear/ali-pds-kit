//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/6.
//

import Foundation

public struct UserInfoModel: PDSModel {
    public let domainID, userID: String
    public let avatar: String
    public let createdAt, updatedAt: Int
    public let email, nickName, phone, role: String
    public let status, userName, welcomeDescription, defaultDriveID: String
    public let userData: UserData

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
    public struct UserData: Codable {
        public let share: String?
    }
}
