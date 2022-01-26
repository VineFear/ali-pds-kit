//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/4.
//

import Foundation

public struct OAuthAccessToken: Codable {
    public let access_token: String
    public let refresh_token: String
    public let token_type: String
    public let expires_in: Int
    public let expire_time: String
}
