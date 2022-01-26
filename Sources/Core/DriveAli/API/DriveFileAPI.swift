//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/6.
//

import Foundation
import NIOHTTP1
import AsyncHTTPClient
import Logging
import Crypto
import NIO
import NIOFoundationCompat

public protocol DriveFileAPI {
    
    // MARK: FILE
    
    // MARK: List
    /// 获取文件列表 POST /v2/file/list, 默认 root
    func getFileList(driveId: String, parentFileId: String, queryParameters: [String: String]?) async throws -> FileDriveModel
    
    
    // MARK: Search
    /// 文件搜索
    func searchDriveFileOrFolder(body: PDSSearchFileRequest) async throws -> PDSSearchFileResponse
    
    
    // MARK: Fetch
    /// 根据路径获取文件或文件夹信息
    func getByPathFileOrFolderInfo(body: PDSGetFileByPathRequest) async throws -> PDSGetFileByPathResponse
    /// 获取文件或文件夹信息
    func getFileOrFolderInfo(body: PDSGetFileRequest) async throws -> PDSGetFileResponse
    /// 获取文件下载地址
    func getFileDownloadUrl(body: PDSGetDownloadUrlRequest, range: ClosedRange<Int>?) async throws -> PDSGetDownloadUrlResponse
    
    
    // MARK: Delete
    /// 删除文件或者文件夹
    func deleteFileOrFolder(driveId: String, fileId: String, permanently: Bool?) async throws -> PDSDeleteFileResponse
    
    
    // MARK: Create
    /// 创建文件夹, 默认 root
    func createFolder(driveId: String, parentFileId: String, name: String) async throws -> PDSCreateFileResponse
    
    /// 创建深度文件夹, 从根目录开始, 例如: a/b/c
    func createDepthFolder(driveId: String, path: URL) async throws -> PDSCreateFileResponse
    
    /// 创建文件， 默认 root
    func createSecFile(driveId: String, parentFileId: String, name: String, size: Int, contentHash: String, partInfoList: [PartInfoList]) async throws -> PDSCreateFileResponse
    /// 创建文件或者文件夹
    func createFileOrFolder(body: PDSCreateFileRequest) async throws -> PDSCreateFileResponse
    
    /// 创建文件或文件夹，并上传, 默认 parentFileId root
    func createAndUploadFile(driveId: String, parentFileId: String, name: String, localPath: String, partInfoList: [PartInfoList]) async throws -> PDSCompleteFileResponse
    
    /// 获取分片上传地址，默认分片大小
    func chunkGetUploadUrl(driveId: String, fileId: String, uploadId: String, size: Int) async throws -> PDSGetUploadUrlResponse
    /// 获取分片上传地址
    func chunkGetUploadUrl(driveId: String, fileId: String, uploadId: String, partInfoList: [PartInfoList]) async throws -> PDSGetUploadUrlResponse
    /// 列举已上传分片
    func chunkListUploadedParts(body: PDSListUploadedPartRequest) async throws -> PDSListUploadedPartResponse
    /// 上传单块文件
    @discardableResult
    func chunkPutUpload(url: String, data: Data, completionHandler: ((ResponseAccumulator.Response, Result<PDSPutChunkResponse, Error>) -> Void)?) throws -> HTTPClient.Task<ResponseAccumulator.Response>
    /// 文件上传完成
    func chunkfileUploadComplete(driveId: String, fileId: String, uploadId: String) async throws -> PDSCompleteFileResponse
    /// 自动上传分片文件
    func startUploadLargeFileChunk(driveId: String, fileId: String, uploadId: String, partInfoList: [PartInfoList], fileUrl: URL, chunkSize: Int) async throws -> PDSCompleteFileResponse
    // MARK: Copy
    // MARK: Move
}

public extension DriveFileAPI {
    
    var bufferSize: Int {
        1024 * 1024 * 5
    }
    
    func getFileList(driveId: String, parentFileId: String, queryParameters: [String: String]? = nil) async throws -> FileDriveModel {
        try await getFileList(driveId: driveId, parentFileId: parentFileId, queryParameters: queryParameters)
    }
    
    /// 获取文件下载地址
    func getFileDownloadUrl(body: PDSGetDownloadUrlRequest, range: ClosedRange<Int>? = nil) async throws -> PDSGetDownloadUrlResponse {
        try await getFileDownloadUrl(body: body, range: range)
    }
    func deleteFileOrFolder(driveId: String, fileId: String, permanently: Bool? = false) async throws -> PDSDeleteFileResponse {
        try await deleteFileOrFolder(driveId: driveId, fileId: fileId, permanently: permanently)
    }
    /// 创建文件夹
    func createFolder(driveId: String, parentFileId: String = "root", name: String) async throws -> PDSCreateFileResponse {
        let body = PDSCreateFileRequest.init(driveId: driveId, parentFileId: parentFileId, name: name)
        return try await createFileOrFolder(body: body)
    }
    /// 创建文件， 默认 root,   part 不传默认是 1
    func createSecFile(driveId: String, parentFileId: String = "root", name: String, size: Int, contentHash: String, partInfoList: [PartInfoList] = []) async throws -> PDSCreateFileResponse {
        var list = partInfoList
        if partInfoList.isEmpty {
            let count = size / bufferSize + ((size % bufferSize) > 0 ? 1 : 0)
            for index in 0..<count {
                let part = PartInfoList(partNumber: index+1)
                list.append(part)
            }
        }
        let body = PDSCreateFileRequest.init(driveId: driveId, parentFileId: parentFileId, name: name, size: size, contentHash: contentHash, partInfoList: list)
        return try await createFileOrFolder(body: body)
    }
    
    /// 创建文件或文件夹，并上传, 默认 parentFileId root
    func createAndUploadFile(driveId: String, parentFileId: String, name: String, localPath: String, partInfoList: [PartInfoList] = []) async throws -> PDSCompleteFileResponse {
        return try await createAndUploadFile(driveId: driveId, parentFileId: parentFileId, name: name, localPath: localPath, partInfoList: partInfoList)
    }
    /// 获取分片上传地址，默认分片大小
    func chunkGetUploadUrl(driveId: String, fileId: String, uploadId: String, size: Int) async throws -> PDSGetUploadUrlResponse {
        var list: [PartInfoList] = []
        let count = size / bufferSize + ((size % bufferSize) > 0 ? 1 : 0)
        for index in 0..<count {
            let part = PartInfoList(partNumber: index+1)
            list.append(part)
        }
        return try await chunkGetUploadUrl(driveId: driveId, fileId: fileId, uploadId: uploadId, partInfoList: list)
    }
    /// 上传单块文件
    @discardableResult
    func chunkPutUpload(url: String, data: Data, completionHandler: ((ResponseAccumulator.Response, Result<PDSPutChunkResponse, Error>) -> Void)? = nil ) throws -> HTTPClient.Task<ResponseAccumulator.Response> {
        return try chunkPutUpload(url: url, data: data, completionHandler: completionHandler)
    }
    /// 自动上传分片文件
    func startUploadLargeFileChunk(driveId: String, fileId: String, uploadId: String, partInfoList: [PartInfoList], fileUrl: URL, chunkSize: Int = 1024 * 1024 * 5) async throws -> PDSCompleteFileResponse {
        return try await startUploadLargeFileChunk(driveId: driveId, fileId: fileId, uploadId: uploadId, partInfoList: partInfoList, fileUrl: fileUrl, chunkSize: chunkSize)
    }
}

class AliDriveFileAPI: DriveFileAPI {
    let endpoint = "https://api.aliyundrive.com/v2"
    let request: AliDriveRequest
    let logger: Logger
    
    init(request: AliDriveRequest, logger: Logger) {
        self.request = request
        self.logger = logger
    }
    /// 创建深度文件夹, 从 root 开始
    func createDepthFolder(driveId: String, path: URL) async throws -> PDSCreateFileResponse {
        var currentPathItems: [String] = path.absoluteString.split(separator: "/").map { "\($0)"}
        func create(parentId: String, path: String) async throws -> PDSCreateFileResponse {
            let fileResponse = try await self.createFolder(driveId: driveId, parentFileId: parentId, name: path)
            // 如果paths为空，直接返回
            if currentPathItems.isEmpty {
                return fileResponse
            } else {
                // 创建
                let needCreatePath = currentPathItems.removeFirst()
                let currentParentId = fileResponse.fileID
                return try await create(parentId: currentParentId, path: needCreatePath)
            }
        }
        if currentPathItems.isEmpty {
            throw AliDriveAPIError.init(statusCode: 500, error: .init(code: "500", message: "路径错误"))
        }
        let needCreatePath = currentPathItems.removeFirst()
        return try await create(parentId: "root", path: needCreatePath)
    }
    
    /// 创建文件或文件夹
    func createFileOrFolder(body: PDSCreateFileRequest) async throws -> PDSCreateFileResponse {
        let url = "\(endpoint)/file/create"
        do {
            let requestBody = try JSONEncoder().encode(body)
            return try await request.send(method: .POST, path: url, body: .data(requestBody))
        } catch {
            throw error
        }
    }
    /// 文件上传完成
    func chunkfileUploadComplete(driveId: String, fileId: String, uploadId: String) async throws -> PDSCompleteFileResponse {
        let url = "\(endpoint)/file/complete"
        do {
            let body = PDSCompleteFileRequest.init(uploadID: uploadId, driveID: driveId, fileID: fileId)
            let requestBody = try JSONEncoder().encode(body)
            return try await request.send(method: .POST, path: url, body: .data(requestBody))
        } catch {
            throw error
        }
    }
}

// MARK: Get
extension AliDriveFileAPI {
    
    func getFileList(driveId: String, parentFileId: String, queryParameters: [String : String]?) async throws -> FileDriveModel {
        let url = "\(endpoint)/file/list"
        
        do {
            
            var body: [String: Any] = ["drive_id": driveId,
                                       "parent_file_id": parentFileId]
            body["limit"] = 50
            body["order_by"] = "updated_at"
            body["order_direction"] = "DESC"
            if let queryParameters = queryParameters {
                body.merge(queryParameters) { (current, _) in current }
            }
            let requestBody = try JSONSerialization.data(withJSONObject: body)
            return try await request.send(method: .POST, path: url, body: .data(requestBody))
        } catch {
            throw error
        }
    }
    
    func searchDriveFileOrFolder(body: PDSSearchFileRequest) async throws -> PDSSearchFileResponse {
        let url = "\(endpoint)/file/search"
        do {
            let requestBody = try JSONEncoder().encode(body)
            return try await request.send(method: .POST, path: url, body: .data(requestBody))
        } catch {
            throw error
        }
    }
    /// 根据路径获取文件或文件夹信息
    func getByPathFileOrFolderInfo(body: PDSGetFileByPathRequest) async throws -> PDSGetFileByPathResponse {
        let url = "\(endpoint)/file/get_by_path"
        do {
            let requestBody = try JSONEncoder().encode(body)
            return try await request.send(method: .POST, path: url, body: .data(requestBody))
        } catch {
            throw error
        }
    }
    /// 获取文件或文件夹信息
    func getFileOrFolderInfo(body: PDSGetFileRequest) async throws -> PDSGetFileResponse {
        let url = "\(endpoint)/file/get"
        do {
            let requestBody = try JSONEncoder().encode(body)
            return try await request.send(method: .POST, path: url, body: .data(requestBody))
        } catch {
            throw error
        }
    }
    /// 获取文件下载地址
    func getFileDownloadUrl(body: PDSGetDownloadUrlRequest, range: ClosedRange<Int>?) async throws -> PDSGetDownloadUrlResponse {
        let url = "\(endpoint)/file/get_download_url"
        do {
            var headers: HTTPHeaders = [:]
            if let range = range {
                headers.add(name: "Range", value: "bytes=\(range.lowerBound)-\(range.upperBound)")
            }
            let requestBody = try JSONEncoder().encode(body)
            return try await request.send(method: .POST, headers: headers, path: url, body: .data(requestBody))
        } catch {
            throw error
        }
    }
}

// MARK: Upload
extension AliDriveFileAPI {
    /// 创建文件或文件夹，并上传,parentFileId 默认 root
    func createAndUploadFile(driveId: String, parentFileId: String, name: String, localPath: String, partInfoList: [PartInfoList]) async throws -> PDSCompleteFileResponse {
        // Get file attributes for this file.
        guard
            let attributes = try? FileManager.default.attributesOfItem(atPath: localPath),
            //            let modifiedAt = attributes[.modificationDate] as? Date,
            let fileSize = (attributes[.size] as? NSNumber)?.intValue
        else {
            throw AliDriveAPIError.init(statusCode: 500, error: .init(code: "500", message: "文件读取失败"))
        }
        let url = URL(fileURLWithPath: localPath)
        // 创建文件
        let contentHash = nativeSha1(path: localPath)
        
        var list = partInfoList
        if partInfoList.isEmpty {
            let count = fileSize / bufferSize + ((fileSize % bufferSize) > 0 ? 1 : 0)
            for index in 0..<count {
                let part = PartInfoList(partNumber: index+1)
                list.append(part)
            }
        }
        let body = PDSCreateFileRequest.init(driveId: driveId, parentFileId: parentFileId, name: name, size: fileSize, contentHash: contentHash, partInfoList: list)
        let chunkInfo = try await createFileOrFolder(body: body)
        guard let chunkDriveId = chunkInfo.driveID else {
            throw AliDriveAPIError.init(statusCode: 500, error: .init(code: "500", message: "上传失败"))
        }
        if let rapid = chunkInfo.rapidUpload, rapid {
            // 预秒传成功，直接返回
            let completeFile = PDSCompleteFileResponse.init(driveID: chunkDriveId, fileID: chunkInfo.fileID)
            return completeFile
        }
        
        guard let chunkList = chunkInfo.partInfoList,
              let chunkUploadId = chunkInfo.uploadID else {
                  throw AliDriveAPIError.init(statusCode: 500, error: .init(code: "500", message: "分片失败"))
              }
        let chunkFileId = chunkInfo.fileID
        return try await self.startUploadLargeFileChunk(driveId: chunkDriveId, fileId: chunkFileId, uploadId: chunkUploadId, partInfoList: chunkList, fileUrl: url)
    }
    
    func nativeSha1(path: String, bufferSize: Int = 1024 * 1024 * 5) -> String {
        // Open file for reading:
        guard let file = FileHandle(forReadingAtPath: path) else {
            return ""
        }
        defer {
            file.closeFile()
        }
        // Create and initialize Sha1 context:
        var sha = Insecure.SHA1()
        // Read up to `bufferSize` bytes, until EOF is reached, and update Sha1 context:
        let invoking = { () -> Bool in
            let data = file.readData(ofLength: bufferSize)
            if data.count > 0 {
                sha.update(data: data)
                return true // Continue
            } else {
                return false // End of file
            }
        }
        
#if os(Linux)
        while (invoking)() {}
#else
        while autoreleasepool(invoking: invoking) { }
#endif
        // Compute the Sha1 digest:
        let digest = sha.finalize()
        let hexDigest = digest.map { String(format: "%02hhx", $0) }.joined()
        return hexDigest
    }
}

// MARK: Large file parts
extension AliDriveFileAPI {
    
    /// 获取分片上传地址
    func chunkGetUploadUrl(driveId: String, fileId: String, uploadId: String, partInfoList: [PartInfoList]) async throws -> PDSGetUploadUrlResponse {
        let url = "\(endpoint)/file/get_upload_url"
        do {
            let body = PDSGetUploadUrlRequest.init(driveId: driveId, fileId: fileId, uploadId: uploadId, partInfoList: partInfoList)
            let requestBody = try JSONEncoder().encode(body)
            return try await request.send(method: .POST, path: url, body: .data(requestBody))
        } catch {
            throw error
        }
    }
    
    /// 列举已上传分片
    func chunkListUploadedParts(body: PDSListUploadedPartRequest) async throws -> PDSListUploadedPartResponse {
        let url = "\(endpoint)/file/list_uploaded_parts"
        do {
            let requestBody = try JSONEncoder().encode(body)
            return try await request.send(method: .POST, path: url, body: .data(requestBody))
        } catch {
            throw error
        }
    }
    
    /// 开始上传
    func startUploadLargeFileChunk(driveId: String, fileId: String, uploadId: String, partInfoList: [PartInfoList], fileUrl: URL, chunkSize: Int) async throws -> PDSCompleteFileResponse {
        /// 串行队列进行上传
        let file = try FileHandle(forReadingFrom: fileUrl)
        let attributes = try FileManager.default.attributesOfItem(atPath: fileUrl.relativePath)
        guard let fileSize = attributes[.size] as? UInt64 else {
            throw AliDriveAPIError.init(statusCode: 500, error: .init(code: "500", message: "文件大小获取失败"))
        }
        // 上传文件
        for item in partInfoList {
            guard let url = item.uploadURL, let index = item.partNumber else {
                self.logger.info("chunk upload error:\(item)")
                throw AliDriveAPIError.init(statusCode: 500, error: .init(code: "500", message: "分片上传失败"))
            }
            /// 获取偏移量
            let partOffSet = UInt64((index - 1) * chunkSize)
            /// 获取文件偏移量
            let fillOffSet = file.offsetInFile
            /// 不相等，不操作
            if partOffSet != fillOffSet {
                file.seek(toFileOffset: partOffSet)
            }
            let data: Data
            /// 是否是最后一片
            if (partOffSet + UInt64(chunkSize)) > fileSize {
                data = file.readDataToEndOfFile()
            } else {
                data = file.readData(ofLength: chunkSize)
            }
            
            if data.count > 0 {
                // 进行上传
                _ = try await self.chunkPutUpload(url: url, data: data).futureResult.get()
            }
        }
        file.closeFile()
        
        self.logger.info("chunk upload finished")
        // 完成回调
        return try await self.chunkfileUploadComplete(driveId: driveId, fileId: fileId, uploadId: uploadId)
    }
    
    /// 单片上传
    func chunkPutUpload(url: String, data: Data, completionHandler: ((ResponseAccumulator.Response, Result<PDSPutChunkResponse, Error>) -> Void)?) throws -> HTTPClient.Task<ResponseAccumulator.Response> {
        let task = try request.chunkDataTask(method: .PUT, path: url, body: .data(data))
        if let completionHandler = completionHandler {
            _ = task.futureResult.map { [self] (response) in
                guard var byteBuffer = response.body else {
                    if response.status == .ok {
                        let customInfo = PDSPutChunkResponse(statusCode: Int(response.status.code), message: response.status.reasonPhrase)
                        completionHandler(response, .success(customInfo))
                        return
                    } else {
                        fatalError("Response body from PDS is missing! This should never happen.")
                    }
                }
                let responseData = byteBuffer.readData(length: byteBuffer.readableBytes)!
                switch response.status.code {
                case 200...299:
                    do {
                        let model = try JSONDecoder().decode(PDSPutChunkResponse.self, from: responseData)
                        completionHandler(response, .success(model))
                    } catch {
                        if let info = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                            logger.debug("info:\n\(info)")
                        }
                        completionHandler(response, .failure(error))
                    }
                case 409:
                    let error = AliDriveAPIError.init(statusCode: Int(response.status.code), error: .init(code: response.status.reasonPhrase, message: "文件已经存在"))
                    completionHandler(response, .failure(error))
                default:
                    let body = response.body?.getString(at: response.body?.readerIndex ?? 0, length: response.body?.readableBytes ?? 0) ?? ""
                    let error = AliDriveAPIError.init(statusCode: Int(response.status.code), error: .init(code: response.status.reasonPhrase, message: body))
                    completionHandler(response, .failure(error))
                }
            }
        }
        return task
    }
}

// MARK: Delete
extension AliDriveFileAPI {
    /// 删除文件或者文件夹
    func deleteFileOrFolder(driveId: String, fileId: String, permanently: Bool?) async throws -> PDSDeleteFileResponse {
        let body = PDSDeleteFileRequest(driveId: driveId, fileId: fileId, permanently: permanently ?? false)
        let url = "\(endpoint)/file/delete"
        do {
            let requestBody = try JSONEncoder().encode(body)
            return try await request.send(method: .POST, path: url, body: .data(requestBody))
        } catch {
            throw error
        }
    }
}
