//
//  APIRepository.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation
import Combine

protocol APIRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension APIRepository {
    func requestURL<T>(endpoint: Endpoint, page: Int? = nil) async throws -> T where T: Codable {
        guard let url = try? endpoint.request(url: baseURL, page: page) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(for: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.noResponse
        }
        
        guard response.isValidStatusCode() else {
            throw APIError.httpCode(HTTPError(code: response.statusCode))
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
