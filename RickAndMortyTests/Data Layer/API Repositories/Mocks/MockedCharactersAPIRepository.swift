//
//  MockedCharactersAPIRepository.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import RickAndMorty

enum APIRepositoryError: Error {
    case invalidModel
}

final class MockedCharactersAPIRepository: TestAPIRepository, Mock, CharactersAPIRepository {
    enum Action: Equatable {
        case getCharacters(page: Int)
        case getEpisodes(id: Int)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    var rickAndMortyCharactersAPI: RickAndMortyCharactersAPI?
    var rickAndMortyEpisodesAPI: RickAndMortyEpisodesAPI?
    
    func getCharacters(page: Int) async throws -> RickAndMortyCharactersAPI {
        add(.getCharacters(page: page))
        
        guard let model = rickAndMortyCharactersAPI else {
            throw APIRepositoryError.invalidModel
        }
        return model
    }
    
    func getEpisode(id: Int) async throws -> RickAndMortyEpisodesAPI {
        add(.getEpisodes(id: id))
        
        guard let model = rickAndMortyEpisodesAPI else {
            throw APIRepositoryError.invalidModel
        }
        return model
    }
}
