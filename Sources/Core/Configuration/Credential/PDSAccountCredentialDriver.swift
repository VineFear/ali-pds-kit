//
//  File.swift
//  
//
//  Created by Finer  Vine on 2022/1/24.
//

import Foundation
import NIOCore

/// Capable of managing CRUD operations for  `PDSAccountCredential`s
public protocol PDSAccountCredentialDriver {
    
    /// 创建凭证
    /// - Returns: 凭证ID
    func createCredential(_ data: PDSAccountCredentials) async throws -> PDSAccountCredentialsID
    
    /// 读凭证
    /// - Returns: 凭证
    func readCredential(_ credentialsID: PDSAccountCredentialsID) async throws -> PDSAccountCredentials
    
    /// 更新凭证
    /// - Returns: 凭证ID
    @discardableResult
    func updateCredential(_ credentialsID: PDSAccountCredentialsID,
                          to data: PDSAccountCredentials) async throws -> PDSAccountCredentialsID
    
    /// 删除凭证
    /// - Returns: 空值
    func deleteCredential(_ credentialsID: PDSAccountCredentialsID) async throws -> Void
}
