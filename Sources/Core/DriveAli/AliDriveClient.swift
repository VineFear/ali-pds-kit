//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/4.
//

import Foundation
import NIO
import Logging
import AsyncHTTPClient

public class AliDriveClient {
    public var user: DriveUserAPI
    public var drive: DriveFileAPI
    
    public let driveRequest: AliDriveRequest
    
    public init(credentialsDriver: PDSAccountCredentialDriver,
                credentials: PDSAccountCredentials, httpClient: HTTPClient, eventLoop: EventLoop, logger: Logger) {
                
        let refreshableToken = OAuthServiceAccount.init(credentialsDriver: credentialsDriver, credentials: credentials, httpClient: httpClient, eventLoop: eventLoop)
        
        driveRequest = AliDriveRequest(httpClient: httpClient, eventLoop: eventLoop, oauth: refreshableToken, logger: logger)
        
        user = AliDriveUserAPI(request: driveRequest)
        drive = AliDriveFileAPI(request: driveRequest, logger: logger)
    }

    /// Hop to a new eventloop to execute requests on.
    /// - Parameter eventLoop: The eventloop to execute requests on.
    public func hopped(to eventLoop: EventLoop) -> AliDriveClient {
        driveRequest.eventLoop = eventLoop
        return self
    }
}
