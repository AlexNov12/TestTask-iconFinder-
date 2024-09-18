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
    
    private var imageCache = NSCache<NSString, UIImage>() // Словарь ключ - строка, значение - картинка
    
    func image(for url: String) -> UIImage? {             // Для поиска в кэше изображений
        return imageCache.object(forKey: url as NSString)
    }
    
    func setImage(_ image: UIImage, for url: String) {    // Для сохранения в кэш изображений
        self.imageCache.setObject(image, forKey: url as NSString)
    }
}
