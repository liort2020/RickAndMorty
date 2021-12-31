//
//  CharactersListViewModel.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import Combine

protocol CharactersListViewModel: ObservableObject {
    var routing: CharactersListViewRouting { get set }
    var characters: [Character] { get set }
    var isLoading: Bool { get set }
    var diContainer: DIContainer { get }
    
    func load() async
    func fetchCharacters() async
}

class RealCharactersListViewModel: CharactersListViewModel {
    @Published var routing: CharactersListViewRouting
    @Published var characters: [Character]
    @Published var isLoading: Bool
    private(set) var diContainer: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(diContainer: DIContainer, characters: [Character] = [], isLoading: Bool = true) {
        self.diContainer = diContainer
        self.characters = characters
        self.isLoading = isLoading
        
        // Configure Routing
        _routing = Published(initialValue: diContainer.appState?.value.routing.charactersList ?? CharactersListViewRouting())

        $routing
            .sink { charactersListViewRouting in
                diContainer.appState?.value.routing.charactersList = charactersListViewRouting
            }
            .store(in: &subscriptions)
    }
    
    func load() async {
        await loading(true)
        
        guard let charactersInteractor = diContainer.interactors?.charactersInteractor else { return }
        
        do {
            let characters = try await charactersInteractor.loadCharacters()
            await updateUI(using: characters)
        } catch {
            print("An error occurred while loading characters: \(error.localizedDescription)")
            await loading(false)
        }
    }
    
    func fetchCharacters() async {
        guard let charactersInteractor = diContainer.interactors?.charactersInteractor else { return }

        do {
            let characters = try await charactersInteractor.fetchCharacters(page: currentPage)
            if characters.count > 0 {
                self.currentPage += 1
                await updateUI(using: characters)
            }
        } catch {
            await loading(false)
        }
    }
    
    // MARK: - Update UI
    @MainActor
    private func updateUI(using characters: [Character]) {
        guard !characters.isEmpty else { return }
        let newCharacters = characters.filter {
            !self.characters.map { $0.id }.contains($0.id)
        }
        self.characters.append(contentsOf: newCharacters)
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
