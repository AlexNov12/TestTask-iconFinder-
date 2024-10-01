//
//  ImageLoaderManager.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit
import Nuke

class ImageLoaderManager {
    
    static let shared = ImageLoaderManager()
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        if let image = ImagePipeline.shared.cache.cachedImage(for: ImageRequest(url: url))?.image {
            completion(image)
        } else {
            ImagePipeline.shared.loadImage(with: url) { result in
                switch result {
                case .success(let response):
                    completion(response.image)
                case .failure:
                    completion(nil)
                }
            }
        }
    }
}
