//
//  CharacterDetailsViewModel.swift
//  RickAndMorty
//
//  Created by Lior Tal on 30/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import Combine

protocol CharacterDetailsViewModel: ObservableObject {
    var routing: CharacterDetailsViewRouting { get set }
    var diContainer: DIContainer { get }
    var character: Character { get set }
    var episodes: [Episode] { get set }
    var isLoading: Bool { get set }
    
    func loadEpisodes() async
    func fetchEpisodes() async
}

class RealCharacterDetailsViewModel: CharacterDetailsViewModel {
    @Published var routing: CharacterDetailsViewRouting
    @Published var character: Character
    @Published var episodes: [Episode] = []
    @Published var isLoading: Bool
    private(set) var diContainer: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(diContainer: DIContainer, character: Character, isLoading: Bool = true) {
        self.diContainer = diContainer
        self.character = character
        self.isLoading = isLoading
        
        // Configure Routing
        _routing = Published(initialValue: diContainer.appState?.value.routing.characterDetails ?? CharacterDetailsViewRouting())

        $routing
            .sink { characterDetailsViewRouting in
                diContainer.appState?.value.routing.characterDetails = characterDetailsViewRouting
            }
            .store(in: &subscriptions)
        
        self.configureEpisodes()
    }
    
    func loadEpisodes() async {
        guard let charactersInteractor = diContainer.interactors?.charactersInteractor else { return }
        
        await loading(true)
        
        let episodeIds = episodes.map { Int($0.id) }
        do {
            let newEpisodes = try await charactersInteractor.loadEpisodes(ids: episodeIds)
            await updateUI(newEpisodes: newEpisodes)
        } catch {
            print("An error occurred while loading episodes: \(error.localizedDescription)")
            await loading(false)
        }
    }
    
    func fetchEpisodes() async {
        let episodeIds = episodes.compactMap { Int($0.id) }
        
        guard let charactersInteractor = diContainer.interactors?.charactersInteractor else { return }
        
        await loading(true)
        
        do {
            let newEpisodes = try await charactersInteractor.fetchEpisodes(ids: episodeIds)
            await updateUI(episodes: newEpisodes)
        } catch {
            print("An error occurred while fetching episodes: \(error.localizedDescription)")
            await loading(false)
        }
    }
    
    private func configureEpisodes() {
        self.episodes = character.getEpisodesSortedById()
    }
    
    // MARK: - Update UI
    @MainActor
    private func updateUI(episodes: [Episode]) {
        self.episodes = episodes
        loading(false)
    }
    
    @MainActor
    private func updateUI(newEpisodes: [Episode]) {
        let newEpisodes = episodes.filter {
            !self.episodes.map { $0.id }.contains($0.id)
        }
        self.episodes.append(contentsOf: newEpisodes)
        loading(false)
    }
    
    @MainActor
    private func loading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    deinit {
        subscriptions.removeAll()
    }
}
