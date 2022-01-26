//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/4.
//

import Foundation

public struct PDSAccountCredentials: Codable {
    public let secret: String
    public init(secret: String) {
        self.secret = secret
    }
}
