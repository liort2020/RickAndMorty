//
//  CharactersDBRepository.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation
import Combine

protocol CharactersDBRepository {
    func fetchCharacters() async throws -> [Character]
    func fetchEpisodes(ids: [Int]) async throws -> [Episode]
    func store(rickAndMortyCharactersAPI: RickAndMortyCharactersAPI) async throws -> [Character]
    func store(rickAndMortyEpisodesAPI: RickAndMortyEpisodesAPI) async throws -> Episode
}

struct RealCharactersDBRepository: CharactersDBRepository {
    private let persistentStore: PersistentStore
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
    }
    
    func fetchCharacters() async throws -> [Character] {
        let fetchRequest = Character.requestAllItems()
        return try await persistentStore.fetch(fetchRequest)
    }
    
    func fetchEpisodes(ids: [Int]) async throws -> [Episode] {
        let fetchRequest = Episode.requestItems(using: ids)
        return try await persistentStore.fetch(fetchRequest)
    }
    
    func store(rickAndMortyCharactersAPI: RickAndMortyCharactersAPI) async throws -> [Character] {
        var characters: [Character] = []
        
        try await withThrowingTaskGroup(of: Character.self) { group in
            rickAndMortyCharactersAPI.characters?.forEach { model in
                let fetchRequest = Character.requestItem(using: model.id)
                group.addTask {
                    return try await persistentStore
                        .update(fetchRequest: fetchRequest) { item in
                            item.name = model.name
                            item.status = model.status
                            item.species = model.species
                            item.type = model.type
                            item.gender = model.gender
                            item.image = model.image
                        } createNew: { context in
                            model.store(in: context)
                        }
                }
            }
            
            for try await character in group {
                characters.append(character)
            }
        }
        return characters
    }
    
    func store(rickAndMortyEpisodesAPI model: RickAndMortyEpisodesAPI) async throws -> Episode {
        let fetchRequest = Episode.requestItem(using: model.id)
        return try await persistentStore
            .update(fetchRequest: fetchRequest) { item in
                item.name = model.name
                item.airDate = model.airDate
                item.episode = model.episode
            } createNew: { context in
                model.store(in: context)
            }
    }
}
