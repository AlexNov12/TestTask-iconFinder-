//
//  Models.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

struct IconResponse: Codable {
    let icons: [IconModel]
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case icons
        case totalCount = "total_count"
    }
    
    struct IconModel: Codable {
        let id: Int
        let tags: [String]
        let sizes: [RasterSize]
        
        enum CodingKeys: String, CodingKey {
            case id = "icon_id"
            case tags
            case sizes = "raster_sizes"
        }
        
        struct RasterSize: Codable {
            let formats: [Format]
            let width: Int
            let height: Int
            
            enum CodingKeys: String, CodingKey {
                case formats
                case width = "size_width"
                case height = "size_height"
            }
            
            struct Format: Codable {
                let format: String
                let previewURL: String
                let downloadURL: String
                
                enum CodingKeys: String, CodingKey {
                    case format
                    case previewURL = "preview_url"
                    case downloadURL = "download_url"
                }
            }
        }
    }
}
