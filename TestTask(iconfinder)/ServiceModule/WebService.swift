//
//  WebService.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import Foundation

protocol RestServiceProtocol {
    func searchIcons(query: String, completion: @escaping (Result<[IconModel], Error>) -> Void)
}

final class RestService: RestServiceProtocol {
    private let apiKey = "E3fJGMECer2qkm3BYLdjFJMfDPM19qnKauakI7zqneuZPGldSBGUuGx4EXBbtIEB"
    private let baseURL = "https://api.iconfinder.com/v4/icons/search"
    
    func searchIcons(query: String, completion: @escaping (Result<[IconModel], Error>) -> Void) {
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "premium", value: "false")
            // URLQueryItem(name: "type", value: "png") // это скрытый параметр, пока не уверен, что нам нужен
        ]
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        // Тут метод для кеша
        
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
                let icons = response.icons
                
                // тут запись в кэш
                
                completion(.success(icons))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
