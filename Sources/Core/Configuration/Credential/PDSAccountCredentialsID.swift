//
//  File.swift
//  
//
//  Created by Finer  Vine on 2022/1/24.
//

import Foundation

/// 这里是凭证🆔
public struct PDSAccountCredentialsID: Equatable, Hashable {
    public let string: String
    public init(string: String) {
        self.string = string
    }
}

extension PDSAccountCredentialsID: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(string: container.decode(String.self))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.string)
    }
}
