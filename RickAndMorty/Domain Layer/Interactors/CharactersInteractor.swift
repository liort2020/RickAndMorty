//
//  CharactersInteractor.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import Combine

protocol CharactersInteractor {
    func loadCharacters() async throws -> [Character]
    func loadEpisodes(ids: [Int]) async throws -> [Episode]
    func fetchCharacters(page: Int) async throws -> [Character]
    func fetchEpisodes(ids: [Int]) async throws -> [Episode]
}

class RealCharactersInteractor: CharactersInteractor {
    private let charactersAPIRepository: CharactersAPIRepository
    private let charactersDBRepository: CharactersDBRepository
    private let appState: AppStateSubject
    
    init(charactersAPIRepository: CharactersAPIRepository,
         charactersDBRepository: CharactersDBRepository,
         appState: AppStateSubject) {
        self.charactersAPIRepository = charactersAPIRepository
        self.charactersDBRepository = charactersDBRepository
        self.appState = appState
    }
    
    func loadCharacters() async throws -> [Character] {
        try await charactersDBRepository.fetchCharacters()
    }
    
    func loadEpisodes(ids: [Int]) async throws -> [Episode] {
        try await charactersDBRepository.fetchEpisodes(ids: ids)
    }
    
    func fetchCharacters(page: Int) async throws -> [Character] {
        // Fetch characters
        let rickAndMortyCharactersAPI = try await charactersAPIRepository.getCharacters(page: page)
        
        // Save to database
        let characters = try await charactersDBRepository.store(rickAndMortyCharactersAPI: rickAndMortyCharactersAPI)
        
        let ids = characters.map {
            $0.getEpisodesIds()
        }.flatMap { $0 }
        let episodesIds = Array(Set(ids)).sorted()
        
        await withThrowingTaskGroup(of: Void.self) { group in
            episodesIds.forEach { episodesId in
                group.addTask {
                    try Task.checkCancellation()
                    let rickAndMortyEpisodesAPI = try await self.charactersAPIRepository.getEpisode(id: episodesId)
                    // Save episode to database
                    let _ = try await self.charactersDBRepository.store(rickAndMortyEpisodesAPI: rickAndMortyEpisodesAPI)
                }
            }
        }
        return characters.sorted(by: { $0.id < $1.id })
    }
    
    func fetchEpisodes(ids: [Int]) async throws -> [Episode] {
        var episodes: [Episode] = []
        
        try await withThrowingTaskGroup(of: Episode.self) { group in
            ids.forEach { id in
                group.addTask {
                    let rickAndMortyEpisodesAPI = try await self.charactersAPIRepository.getEpisode(id: id)
                    // Save to database
                    return try await self.charactersDBRepository.store(rickAndMortyEpisodesAPI: rickAndMortyEpisodesAPI)
                }
            }
            
            for try await episode in group {
                episodes.append(episode)
            }
        }
        return episodes.sorted(by: { $0.id < $1.id })
    }
}
