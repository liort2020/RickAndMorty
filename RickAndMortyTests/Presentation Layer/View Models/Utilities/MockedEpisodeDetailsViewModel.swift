//
//  MockedEpisodeDetailsViewModel.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 31/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import RickAndMorty

class MockedEpisodeDetailsViewModel: Mock, EpisodeDetailsViewModel {
    // MARK: EpisodeDetailsViewModel
    var diContainer: DIContainer
    var routing: EpisodeDetailsViewRouting
    var episode: Episode
    
    enum Action: Equatable {
        // We currently have no actions in this view model
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    init(diContainer: DIContainer, routing: EpisodeDetailsViewRouting, episode: Episode) {
        self.diContainer = diContainer
        self.routing = routing
        self.episode = episode
    }
}
