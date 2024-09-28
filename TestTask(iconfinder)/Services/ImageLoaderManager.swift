//
//  ImageLoaderManager.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit
import Nuke

protocol ImageLoaderManagerProtocol {
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}

class ImageLoaderManager: ImageLoaderManagerProtocol {

    private let iconCacheManager: IconCacheManagerProtocol
    
    init(iconCacheManager: IconCacheManagerProtocol) {
        self.iconCacheManager = iconCacheManager
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        if let cachedImage = iconCacheManager.image(for: urlString) {
            completion(cachedImage)
            return
        }
        
        Task {
            do {
                let image = try await ImagePipeline.shared.image(for: url)
                self.iconCacheManager.setImage(image, for: urlString)
                completion(image)
            } catch {
                completion(nil)
            }
        }
    }
}
