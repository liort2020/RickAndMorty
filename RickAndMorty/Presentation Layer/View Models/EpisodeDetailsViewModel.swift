//
//  EpisodeDetailsViewModel.swift
//  RickAndMorty
//
//  Created by Lior Tal on 30/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import Combine

protocol EpisodeDetailsViewModel: ObservableObject {
    var routing: EpisodeDetailsViewRouting { get set }
    var diContainer: DIContainer { get }
    var episode: Episode { get set }
}

class RealEpisodeDetailsViewModel: EpisodeDetailsViewModel {
    @Published var routing: EpisodeDetailsViewRouting
    @Published var episode: Episode
    private(set) var diContainer: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(diContainer: DIContainer, episode: Episode) {
        self.diContainer = diContainer
        self.episode = episode
        
        // Configure Routing
        _routing = Published(initialValue: diContainer.appState?.value.routing.episodeDetails ?? EpisodeDetailsViewRouting())

        $routing
            .sink { episodeDetailsViewRouting in
                diContainer.appState?.value.routing.episodeDetails = episodeDetailsViewRouting
            }
            .store(in: &subscriptions)
    }
    
    deinit {
        subscriptions.removeAll()
    }
}
