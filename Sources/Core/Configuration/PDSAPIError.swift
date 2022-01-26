//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/4.
//

import Foundation
import NIOHTTP1

protocol PDSAPIError: Error {
    
}

enum OauthRefreshError: PDSAPIError {
    case psdOAuthNoResponse(HTTPResponseStatus)
    case psdCredentialsNotFound
    
    var localizedDescription: String {
        switch self {
        case .psdOAuthNoResponse(let status):
            return "A request to the OAuth authorization server failed with response status \(status.code)."
        case .psdCredentialsNotFound:
            return "credentials not found"
        }
    }
}
