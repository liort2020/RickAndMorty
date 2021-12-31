//
//  RickAndMortyEndpoint.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

extension RealCharactersAPIRepository {
    enum RickAndMortyEndpoint: Endpoint {
        case getCharacters
        case getEpisode(id: Int)
        
        var path: String {
            switch self {
            case .getCharacters:
                return "/character"
            case .getEpisode(let id):
                return "/episode/\(id)"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .getCharacters, .getEpisode:
                return .get
            }
        }
        
        var headers: [String : String]? {
            ["Content-Type": "application/json"]
        }
        
        func queryParameters(page: Int?) -> [String: String]? {
            guard let page = page else { return nil }
            return ["page": "\(page)"]
        }
        
        func body() throws -> Data? {
            return nil
        }
    }
}
