//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/4.
//

import Foundation
import NIO
import AsyncHTTPClient

protocol PDSAPIRequest: AnyObject {
    var refreshableToken: OAuthRefreshable { get }
    //    var project: String { get }
    var httpClient: HTTPClient { get }
    var responseDecoder: JSONDecoder { get }
    var currentToken: OAuthAccessToken? { get set }
    var tokenCreatedTime: Date? { get set }
    
    /// As part of an API request this returns a valid OAuth token to use with any of the MsGraph.
    /// - Parameter closure: The closure to be executed with the valid access token.
    func withToken<PDSModel>(_ closure: @escaping (OAuthAccessToken) async throws -> PDSModel) async throws -> PDSModel
}

extension PDSAPIRequest {
    public func withToken<PDSModel>(_ closure: @escaping (OAuthAccessToken) async throws -> PDSModel) async throws -> PDSModel {
        guard let token = currentToken,
              let created = tokenCreatedTime,
              refreshableToken.isFresh(token: token, created: created) else {
                  let newToken = try await refreshableToken.refresh()
                  self.currentToken = newToken
                  self.tokenCreatedTime = Date()
                  return try await closure(newToken)
              }
        
        return try await closure(token)
    }
}
