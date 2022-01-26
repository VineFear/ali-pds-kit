//
//  File.swift
//  
//
//  Created by Finer  Vine on 2022/1/24.
//

import Foundation
import NIOCore

public struct MemoryAccountCredential: PDSAccountCredentialDriver {

    public let storage: Storage
    
    public final class Storage {
        public var sessions: [PDSAccountCredentialsID: PDSAccountCredentials]
        public let queue: DispatchQueue
        public init() {
            self.sessions = [:]
            self.queue = DispatchQueue(label: "MemorySessions.Storage")
        }
    }
    
    public init(storage: Storage) {
        self.storage = storage
    }
    
    public func createCredential(_ data: PDSAccountCredentials) async throws -> PDSAccountCredentialsID {
        let credentialsID = PDSAccountCredentialsID.init(string: data.secret)
        self.storage.queue.sync {
            self.storage.sessions[credentialsID] = data
        }
        return credentialsID
    }
    
    public func readCredential(_ credentialsID: PDSAccountCredentialsID) async throws -> PDSAccountCredentials {
        let credentials = self.storage.queue.sync { self.storage.sessions[credentialsID] }
        guard let credentials = credentials else {
            throw OauthRefreshError.psdCredentialsNotFound
        }
        return credentials
    }
    
    public func updateCredential(_ credentialsID: PDSAccountCredentialsID, to data: PDSAccountCredentials) async throws -> PDSAccountCredentialsID {
        self.storage.queue.sync { self.storage.sessions[credentialsID] = data }
        return credentialsID
    }
    
    public func deleteCredential(_ credentialsID: PDSAccountCredentialsID) async throws {
        self.storage.queue.sync { self.storage.sessions[credentialsID] = nil }
    }
    
}
