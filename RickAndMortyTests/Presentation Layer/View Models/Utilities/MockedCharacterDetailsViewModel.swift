//
//  MockedCharacterDetailsViewModel.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 31/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import RickAndMorty

class MockedCharacterDetailsViewModel: Mock, CharacterDetailsViewModel {
    // MARK: CharacterDetailsViewModel
    var diContainer: DIContainer
    var routing: CharacterDetailsViewRouting
    var character: Character
    var episodes: [Episode]
    var isLoading: Bool
    
    enum Action: Equatable {
        case loadEpisodes
        case fetchEpisodes
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    init(diContainer: DIContainer, routing: CharacterDetailsViewRouting, character: Character, episodes: [Episode], isLoading: Bool = true) {
        self.diContainer = diContainer
        self.routing = routing
        self.character = character
        self.episodes = episodes
        self.isLoading = isLoading
    }
    
    func loadEpisodes() async {
        add(.loadEpisodes)
    }
    
    func fetchEpisodes() async {
        add(.fetchEpisodes)
    }
}
