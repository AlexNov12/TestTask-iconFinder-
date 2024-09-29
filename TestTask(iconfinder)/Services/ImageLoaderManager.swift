//
//  ImageLoaderManager.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit
import Nuke

protocol ImageLoaderManagerProtocol {
    func loadImage(from urlString: String) async throws -> UIImage
}

class ImageLoaderManager: ImageLoaderManagerProtocol {

    private let iconCacheManager: IconCacheManagerProtocol
    
    init(iconCacheManager: IconCacheManagerProtocol) {
        self.iconCacheManager = iconCacheManager
    }
    
    func loadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        if let cachedImage = iconCacheManager.image(for: urlString) {
            return cachedImage
        }
        
        do {
            let image = try await ImagePipeline.shared.image(for: url)
            self.iconCacheManager.setImage(image, for: urlString)
            return image
        } catch {
            throw NSError(domain: "Invalid cache", code: 0, userInfo: nil)
        }
    }
}
