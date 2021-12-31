//
//  MockedCharactersInteractor.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import SwiftUI
import Combine
@testable import RickAndMorty

class MockedCharactersInteractor: Mock, CharactersInteractor {
    enum Action: Equatable {
        case loadCharacters
        case loadEpisodes(ids: [Int])
        case fetchCharacters(page: Int)
        case fetchEpisodes(ids: [Int])
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    var characters: [Character] = []
    var episodes: [Episode] = []
    
    func loadCharacters() async throws -> [Character] {
        add(.loadCharacters)
        return characters
    }
    
    func loadEpisodes(ids: [Int]) async throws -> [Episode] {
        add(.loadEpisodes(ids: ids))
        return episodes
    }
    
    func fetchCharacters(page: Int) async throws -> [Character] {
        add(.fetchCharacters(page: page))
        return characters
    }
    
    func fetchEpisodes(ids: [Int]) async throws -> [Episode] {
        add(.fetchEpisodes(ids: ids))
        return episodes
    }
}
