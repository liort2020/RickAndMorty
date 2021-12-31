//
//  MockedCharactersDBRepository.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import SwiftUI
import Combine
@testable import RickAndMorty

final class MockedCharactersDBRepository: Mock, CharactersDBRepository {
    enum Action: Equatable {
        case fetchCharacters
        case fetchEpisodes(ids: [Int])
        case store(rickAndMortyCharactersAPI: RickAndMortyCharactersAPI)
        case store(rickAndMortyEpisodesAPI: RickAndMortyEpisodesAPI)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    var characters: [Character] = []
    var episodes: [Episode] = []
    
    func fetchCharacters() async throws -> [Character] {
        add(.fetchCharacters)
        return characters
    }
    
    func fetchEpisodes(ids: [Int]) async throws -> [Episode] {
        add(.fetchEpisodes(ids: ids))
        return episodes
    }
    
    func store(rickAndMortyCharactersAPI: RickAndMortyCharactersAPI) async throws -> [Character] {
        add(.store(rickAndMortyCharactersAPI: rickAndMortyCharactersAPI))
        return characters
    }
    
    func store(rickAndMortyEpisodesAPI: RickAndMortyEpisodesAPI) async throws -> Episode {
        add(.store(rickAndMortyEpisodesAPI: rickAndMortyEpisodesAPI))
        return episodes[0]
    }
}
