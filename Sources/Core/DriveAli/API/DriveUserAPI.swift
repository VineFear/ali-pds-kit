//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/6.
//

import Foundation
import NIO

public protocol DriveUserAPI {
    /// 获取用户信息
    func getUser() async throws -> UserInfoModel
}

class AliDriveUserAPI: DriveUserAPI {
    let endpoint = "https://api.aliyundrive.com/v2"
    let request: AliDriveRequest
    
    init(request: AliDriveRequest) {
        self.request = request
    }
    
    func getUser() async throws -> UserInfoModel {
        let url = "\(endpoint)/user/get"
        return try await request.send(method: .POST, path: url)
    }
}
