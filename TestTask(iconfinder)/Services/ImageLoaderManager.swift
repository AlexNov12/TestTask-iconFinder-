//
//  ImageLoaderManager.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

class ImageLoaderManager {
    static let shared = ImageLoaderManager()
    
    private init() {}
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = IconCacheManager.shared.image(for: urlString) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            IconCacheManager.shared.setImage(image, for: urlString)
            completion(image)
        }.resume()
    }
}
