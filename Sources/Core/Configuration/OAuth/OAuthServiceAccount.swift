//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/4.
//

import Foundation
import NIOHTTP1
import NIO
import NIOFoundationCompat
import AsyncHTTPClient

class OAuthServiceAccount: OAuthRefreshable {
    let httpClient: HTTPClient
    let eventLoop: EventLoop
    
    private let credentialsDriver: PDSAccountCredentialDriver
    private let credentials: PDSAccountCredentials
    
    private let decoder = JSONDecoder()

    var credentialsID: PDSAccountCredentialsID {
        get async throws {
            try await self.credentialsDriver.createCredential(self.credentials)
        }
    }
    
    init(credentialsDriver: PDSAccountCredentialDriver,
         credentials:PDSAccountCredentials,
         httpClient: HTTPClient, eventLoop: EventLoop) {
        self.credentialsDriver = credentialsDriver
        self.credentials = credentials
        self.httpClient = httpClient
        self.eventLoop = eventLoop
    }
    
    func refresh() async throws -> OAuthAccessToken {
        
        let headers: HTTPHeaders = ["Content-Type": "application/json;charset=UTF-8"]
        let credentials = try await self.credentialsDriver.readCredential(credentialsID)
        
        let body: HTTPClient.Body = .string(#"{"refresh_token":"\#(credentials.secret)"}"#)
        let tokenUrl = PDSOAUTHTokenUrl
        
        let request = try HTTPClient.Request(url: tokenUrl, method: .POST, headers: headers, body: body)
        let response = try await httpClient.execute(request: request, eventLoop: .delegate(on: self.eventLoop)).get()
        guard var byteBuffer = response.body,
        let responseData = byteBuffer.readData(length: byteBuffer.readableBytes),
        response.status == .ok else {
            throw OauthRefreshError.psdOAuthNoResponse(response.status)
        }

        let tokenModel = try self.decoder.decode(OAuthAccessToken.self, from: responseData)
        let newCredentials = PDSAccountCredentials.init(secret: tokenModel.refresh_token)
        try await self.credentialsDriver.updateCredential(credentialsID, to: newCredentials)
        
        return tokenModel
    }
}
