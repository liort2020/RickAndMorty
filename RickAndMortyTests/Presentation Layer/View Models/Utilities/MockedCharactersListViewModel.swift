//
//  MockedCharactersListViewModel.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 31/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import RickAndMorty

class MockedCharactersListViewModel: Mock, CharactersListViewModel {
    // MARK: CharactersListViewModel
    var diContainer: DIContainer
    var routing: CharactersListViewRouting
    var characters: [Character]
    var isLoading: Bool
    
    enum Action: Equatable {
        case load
        case fetchCharacters
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    init(diContainer: DIContainer, routing: CharactersListViewRouting, characters: [Character] = [], isLoading: Bool = true) {
        self.diContainer = diContainer
        self.routing = routing
        self.characters = characters
        self.isLoading = isLoading
    }
    
    func load() async {
        add(.load)
    }
    
    func fetchCharacters() async {
        add(.fetchCharacters)
    }
}
