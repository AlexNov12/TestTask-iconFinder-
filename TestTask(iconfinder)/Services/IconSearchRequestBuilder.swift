//
//  IconSearchRequestBuilder.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 30.09.2024.
//

import Foundation

protocol IconSearchRequestBuilderProtocol {
    func createRequest(query: String, count: Int, offset: Int) -> URLRequest?
}

final class IconSearchRequestBuilder: IconSearchRequestBuilderProtocol {
    
    private let apiKey = "E3fJGMECer2qkm3BYLdjFJMfDPM19qnKauakI7zqneuZPGldSBGUuGx4EXBbtIEB"
    private let baseURL = "https://api.iconfinder.com/v4/icons/search"
    
    func createRequest(query: String, count: Int, offset: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "count", value: "\(count)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "premium", value: "false")
        ]
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        return request
    }
}
