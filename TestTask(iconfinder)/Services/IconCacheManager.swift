//
//  IconCacheManager.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import Foundation
import UIKit

class IconCacheManager {
    static let shared = IconCacheManager()
    private init() {}

    private var cache = NSCache<NSString, UIImage>()

    func image(for url: String) -> UIImage? {
        return cache.object(forKey: url as NSString)
    }

    func setImage(_ image: UIImage, for url: String) {
        cache.setObject(image, forKey: url as NSString)
    }
}
