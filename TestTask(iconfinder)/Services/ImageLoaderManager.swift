//
//  ImageLoaderManager.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

protocol ImageLoaderManagerProtocol {
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}


class ImageLoaderManager: ImageLoaderManagerProtocol {

    static let shared = ImageLoaderManager(iconCacheManager: IconCacheManager())

    private let iconCacheManager: IconCacheManagerProtocol
    
    init(iconCacheManager: IconCacheManagerProtocol){
        self.iconCacheManager = iconCacheManager
    }

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = iconCacheManager.image(for: urlString) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self?.iconCacheManager.setImage(image, for: urlString)
            completion(image)
        }
        task.resume()
    }
}
