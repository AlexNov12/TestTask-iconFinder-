//
//  WebService.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import Foundation

protocol IconSearchServiceProtocol {
    func searchIcons(query: String, completion: @escaping ([IconModel]?, Error?) -> Void)
}

class IconSearchService: IconSearchServiceProtocol {
    let apiKey = "E3fJGMECer2qkm3BYLdjFJMfDPM19qnKauakI7zqneuZPGldSBGUuGx4EXBbtIEB"
    let baseURL = "https://api.iconfinder.com/v4/icons/search"
    
    func searchIcons(query: String, completion: @escaping ([IconModel]?, Error?) -> Void) {
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "premium", value: "false")
        ]
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(IconResponse.self, from: cachedResponse.data)
                let icons = response.icons
                completion(icons, nil)
            } catch {
                completion(nil, error)
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data, let urlResponse = response else {
                completion(nil, NSError(domain: "No data or response", code: 0, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(IconResponse.self, from: data)
                let icons = response.icons
                
                let cachedResponse = CachedURLResponse(response: urlResponse, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                
                completion(icons, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}

