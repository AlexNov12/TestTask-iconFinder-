//
//  Models.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import Foundation

// JSON array
struct IconResponse: Codable {
    let icons: [IconModel]
}

struct IconModel: Codable {
    let iconId: Int
    let tags: [String]
    let rasterSizes: [RasterSizes]
}

struct RasterSizes: Codable {
    let formats: [Format]
    let sizeWidth: Int
    let sizeHeight: Int
}

struct Format: Codable {
    let format: String
    let previewUrl: String
    let downloadUrl: String
}
