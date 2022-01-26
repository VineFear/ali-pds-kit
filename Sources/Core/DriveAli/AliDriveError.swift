//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/6.
//

import Foundation

enum AliDriveError: PDSAPIError {
    case unknownError(String)
    
    var localizedDescription: String {
        switch self {
        case .unknownError(let reason):
            return "An unknown error occured: \(reason)"
        }
    }
}

struct AliDriveAPIError: Codable, PDSAPIError {
    /// An HTTP status code value, without the textual description.
    public var statusCode: Int
    public var error: AliDriveAPIErrorBody
}

struct AliDriveAPIErrorBody: Codable {
    public var code: String
    public var message: String
}
