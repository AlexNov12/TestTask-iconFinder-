//
//  IconCacheManager.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit
import Nuke

protocol IconCacheManagerProtocol {
    func image(for url: String) -> UIImage?
    func setImage(_ image: UIImage, for url: String)
}

class IconCacheManager: IconCacheManagerProtocol {
    
    private let memoryCache = ImageCache.shared
    
    init() {
        memoryCache.costLimit = 1024 * 1024 * 100
        memoryCache.countLimit = 100
        memoryCache.ttl = 120
    }
    
    func image(for url: String) -> UIImage? {
        guard let url = URL(string: url) else { return nil }
        let request = ImageRequest(url: url)
        let cacheKey = ImageCacheKey(request: request)
        return memoryCache[cacheKey]?.image
    }
    
    func setImage(_ image: UIImage, for url: String) {
        guard let url = URL(string: url) else { return }
        let request = ImageRequest(url: url)
        let cacheKey = ImageCacheKey(request: request)
        memoryCache[cacheKey] = ImageContainer(image: image)
    }
}
