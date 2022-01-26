//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/4.
//

import Foundation
import NIO

let PDSOAUTHTokenUrl = "https://api.aliyundrive.com/token/refresh"

public protocol OAuthRefreshable {
    func isFresh(token: OAuthAccessToken, created: Date) -> Bool
    func refresh() async throws -> OAuthAccessToken
}

extension OAuthRefreshable {
    public func isFresh(token: OAuthAccessToken, created: Date) -> Bool {
        let now = Date()
        // Check if the token is about to expire within the next 15 seconds.
        // This gives us a buffer and avoids being too close to the expiration when making requests.
        let expiration = created.addingTimeInterval(TimeInterval(token.expires_in - 15))
        
        return expiration > now
    }
}
