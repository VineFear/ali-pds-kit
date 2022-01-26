//
//  File.swift
//  
//
//  Created by Finer  Vine on 2021/2/15.
//

import Foundation

public struct PDSListUploadedPartResponse: PDSModel {
    let fileID, nextPartNumberMarker, uploadID: String?
    let uploadedParts: [PartInfoList]?

    enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case nextPartNumberMarker = "next_part_number_marker"
        case uploadID = "upload_id"
        case uploadedParts = "uploaded_parts"
    }
}
