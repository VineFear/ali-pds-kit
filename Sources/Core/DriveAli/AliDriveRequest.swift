//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/4.
//

import Foundation
import NIO
import NIOFoundationCompat
import NIOHTTP1
import Logging
import AsyncHTTPClient

public class AliDriveRequest: PDSAPIRequest {
    
    let httpClient: HTTPClient
    let responseDecoder: JSONDecoder = JSONDecoder()
    var tokenCreatedTime: Date?
    var eventLoop: EventLoop
    var currentToken: OAuthAccessToken?
    
    let refreshableToken: OAuthRefreshable
    
    let logger: Logger
    
    init(httpClient: HTTPClient, eventLoop: EventLoop, oauth: OAuthRefreshable, logger: Logger) {
        self.refreshableToken = oauth
        self.httpClient = httpClient
        self.eventLoop = eventLoop
        self.logger = logger
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self.responseDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    /// 普通上传
    public func send<PDM: PDSModel>(method: HTTPMethod, headers: HTTPHeaders = [:], path: String, query: String = "", body: HTTPClient.Body = .string("{}")) async throws -> PDM {
        return try await withToken { token in
            let response = try await self._send(method: method, headers: headers, path: path, query: query, body: body, accessToken: token.access_token)
            do {
                let model = try self.responseDecoder.decode(PDM.self, from: response)
                return model
            } catch {
                if let info = try? JSONSerialization.jsonObject(with: response, options: .allowFragments) {
                    self.logger.debug("info:\n\(info)")
                }
                throw error
            }
        }
    }
    
    /// 块上传
    public func chunkDataTask(method: HTTPMethod, headers: HTTPHeaders = [:], path: String, body: HTTPClient.Body) throws -> HTTPClient.Task<ResponseAccumulator.Response> {
        var _headers: HTTPHeaders = [:]
        headers.forEach { _headers.replaceOrAdd(name: $0.name, value: $0.value) }
        let request = try HTTPClient.Request(url: "\(path)", method: method, headers: _headers, body: body)
        let delegate = ResponseAccumulator(request: request)
        let task = httpClient.execute(request: request, delegate: delegate, eventLoop: .delegate(on: self.eventLoop))
        return task
    }
    
    /// 上传
    private func _send(method: HTTPMethod, headers: HTTPHeaders, path: String, query: String, body: HTTPClient.Body, accessToken: String) async throws -> Data {
        var _headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)",
                                     "Content-Type": "application/json"]
        headers.forEach { _headers.replaceOrAdd(name: $0.name, value: $0.value) }
        let request = try HTTPClient.Request(url: "\(path)", method: method, headers: _headers, body: body)
        let response = try await httpClient.execute(request: request, eventLoop: .delegate(on: self.eventLoop)).get()
        // If we get a 204 for example in the delete api call just return an empty body to decode.
        if response.status == .noContent {
            return "{}".data(using: .utf8)!
        }
        
        guard var byteBuffer = response.body else {
            fatalError("Response body from PDS is missing! This should never happen.")
        }
        let responseData = byteBuffer.readData(length: byteBuffer.readableBytes)!
        
        switch response.status.code {
        case 200...299:
            return responseData
        case 401:
            /// 每次刷新间隔五分钟
            if let created = self.tokenCreatedTime, created.addingTimeInterval(5) > Date(){
                let newToken = try await self.refreshableToken.refresh()
                self.currentToken = newToken
                self.tokenCreatedTime = Date()
                return try await self._send(method: method, headers: headers, path: path, query: query, body: body, accessToken: newToken.access_token)
            } else { // 进入默认错误
                fallthrough
            }
        default:
            let error: Error
            if let jsonError = try? self.responseDecoder.decode(AliDriveAPIErrorBody.self, from: responseData) {
                error = AliDriveAPIError.init(statusCode: Int(response.status.code), error: jsonError)
            } else {
                let body = response.body?.getString(at: response.body?.readerIndex ?? 0, length: response.body?.readableBytes ?? 0) ?? ""
                error = AliDriveAPIError.init(statusCode: Int(response.status.code), error: .init(code: response.status.reasonPhrase, message: body))
            }
            throw error
        }
    }
}
