//
//  Endpoint.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    
    func queryParameters(page: Int?) -> [String: String]?
    func body() throws -> Data?
}

extension Endpoint {
    func request(url: String, page: Int? = nil) throws -> URLRequest? {
        guard var urlComponents = URLComponents(string: url + path) else { throw APIError.invalidURL }
        
        if let queryParameters = queryParameters(page: page) {
            urlComponents.queryItems = queryParameters.enumerated().compactMap { item in
                URLQueryItem(name: item.element.key, value: item.element.value)
            }
        }
        
        guard let urlPath = urlComponents.url else { throw APIError.invalidURL }
        
        var urlRequest = URLRequest(url: urlPath)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try body()
        return urlRequest
    }
}
