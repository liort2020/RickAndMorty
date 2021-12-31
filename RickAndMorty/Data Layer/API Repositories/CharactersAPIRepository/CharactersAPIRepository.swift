//
//  CharactersAPIRepository.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation
import Combine

protocol CharactersAPIRepository: APIRepository {
    func getCharacters(page: Int) async throws -> RickAndMortyCharactersAPI
    func getEpisode(id: Int) async throws -> RickAndMortyEpisodesAPI
}

class RealCharactersAPIRepository: CharactersAPIRepository {
    let session: URLSession
    let baseURL: String
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func getCharacters(page: Int) async throws -> RickAndMortyCharactersAPI {
        return try await requestURL(endpoint: RickAndMortyEndpoint.getCharacters, page: page)
    }
    
    func getEpisode(id: Int) async throws -> RickAndMortyEpisodesAPI {
        try await requestURL(endpoint: RickAndMortyEndpoint.getEpisode(id: id))
    }
}
