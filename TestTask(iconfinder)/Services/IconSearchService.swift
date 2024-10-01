//
//  WebService.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import Foundation

protocol IconSearchServiceProtocol {
    func searchIcons(query: String, count: Int, offset: Int, completion: @escaping (Result<IconResponse, Error>) -> Void)
}

final class IconSearchService: IconSearchServiceProtocol {
    
    private let iconSearchRequestBuilder: IconSearchRequestBuilderProtocol
    
    init(iconSearchRequestBuilder: IconSearchRequestBuilderProtocol) {
        self.iconSearchRequestBuilder = iconSearchRequestBuilder
    }
    
    func searchIcons(query: String, count: Int, offset: Int, completion: @escaping (Result<IconResponse, Error>) -> Void) {
        guard let request = iconSearchRequestBuilder.createRequest(query: query, count: count, offset: offset) else {
            completion(.failure(NSError(domain: "Invalid request", code: 0, userInfo: nil)))
            return
        }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(IconResponse.self, from: cachedResponse.data)
                completion(.success(response))
            } catch {
                completion(.failure(NSError(domain: "Invalid cache", code: 0, userInfo: nil)))
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
                                                              
            guard let data = data, let urlResponse = response else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
                                                              
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(IconResponse.self, from: data)
                
                let cachedResponse = CachedURLResponse(response: urlResponse, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
