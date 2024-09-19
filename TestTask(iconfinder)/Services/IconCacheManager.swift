//
//  IconCacheManager.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

protocol IconCacheManagerProtocol {
    func image(for url: String) -> UIImage?
    func setImage(_ image: UIImage, for url: String)
}

class IconCacheManager: IconCacheManagerProtocol {

    private var imageCache = NSCache<NSString, UIImage>()

    func image(for url: String) -> UIImage? {
        return imageCache.object(forKey: url as NSString)
    }

    func setImage(_ image: UIImage, for url: String) {
        imageCache.setObject(image, forKey: url as NSString)
    }
}
