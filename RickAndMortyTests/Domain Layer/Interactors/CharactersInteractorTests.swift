//
//  CharactersInteractorTests.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
import CoreData
@testable import RickAndMorty

final class CharactersInteractorTests: XCTestCase {
    private let appState = CurrentValueSubject<AppState, Never>(AppState())
    private lazy var mockedCharactersAPIRepository = MockedCharactersAPIRepository()
    private lazy var mockedCharactersDBRepository = MockedCharactersDBRepository()
    private lazy var fakeCharacters = FakeCharacters.all
    private lazy var fakeEpisodes = FakeEpisodes.all
    
    var testableObject: RealCharactersInteractor?
    
    override func setUp() {
        super.setUp()
        appState.value = AppState()
        testableObject = RealCharactersInteractor(charactersAPIRepository: mockedCharactersAPIRepository,
                                                  charactersDBRepository: mockedCharactersDBRepository,
                                                  appState: appState)
    }
    
    func test_loadCharacters() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        mockedCharactersAPIRepository.actions = MockedList(expectedActions: [])
        mockedCharactersDBRepository.actions = MockedList(expectedActions: [
            .fetchCharacters
        ])
        
        // Set DBRepository response
        mockedCharactersDBRepository.characters = fakeCharacters
        
        do {
            // When
            let characters = try await testableObject.loadCharacters()
            
            // Then
            XCTAssertFalse(characters.isEmpty)
            XCTAssertEqual(characters.count, self.fakeCharacters.count, "Receive \(characters.count) items instead of \(self.fakeCharacters.count) items")
            self.mockedCharactersAPIRepository.verify()
            self.mockedCharactersDBRepository.verify()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_loadEpisodes() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let ids = fakeEpisodes.map { Int($0.id) }
        mockedCharactersAPIRepository.actions = MockedList(expectedActions: [])
        mockedCharactersDBRepository.actions = MockedList(expectedActions: [
            .fetchEpisodes(ids: ids)
        ])
        
        // Set DBRepository response
        mockedCharactersDBRepository.episodes = fakeEpisodes
        
        do {
            // When
            let episodes = try await testableObject.loadEpisodes(ids: ids)
            
            // Then
            XCTAssertFalse(episodes.isEmpty)
            XCTAssertEqual(episodes.count, self.fakeEpisodes.count, "Receive \(episodes.count) items instead of \(self.fakeEpisodes.count) items")
            self.mockedCharactersAPIRepository.verify()
            self.mockedCharactersDBRepository.verify()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_fetchCharacters() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let page = 1
        mockedCharactersAPIRepository.actions = MockedList(expectedActions: [
            .getCharacters(page: page)
        ])
        mockedCharactersDBRepository.actions = MockedList(expectedActions: [
            .fetchCharacters
        ])
        
        // Set APIRepository response
        let rickAndMortyCharactersAPI: RickAndMortyCharactersAPI = try XCTUnwrap(MockedRickAndMortyAPI.load(fromResource: MockedRickAndMortyAPI.mockedCharacterFileName))
        mockedCharactersAPIRepository.rickAndMortyCharactersAPI = rickAndMortyCharactersAPI
        
        // Set DBRepository response
        mockedCharactersDBRepository.characters = fakeCharacters
        
        do {
            // When
            let characters = try await testableObject.fetchCharacters(page: page)
            
            // Then
            XCTAssertFalse(characters.isEmpty)
            XCTAssertEqual(characters.count, self.fakeCharacters.count, "Receive \(characters.count) items instead of \(self.fakeCharacters.count) items")
            self.mockedCharactersAPIRepository.verify()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_fetchEpisodes() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let ids = fakeEpisodes.map { Int($0.id) }
        
        let mockedCharactersAPIRepositoryExpectedActions: [MockedCharactersAPIRepository.Action] = ids.map {
            .getEpisodes(id: $0)
        }
        mockedCharactersAPIRepository.actions = MockedList(expectedActions: mockedCharactersAPIRepositoryExpectedActions)
        mockedCharactersDBRepository.actions = MockedList(expectedActions: [
            .fetchEpisodes(ids: ids)
        ])
        
        // Set APIRepository response
        let rickAndMortyEpisodesAPI: RickAndMortyEpisodesAPI = try XCTUnwrap(MockedRickAndMortyAPI.load(fromResource: MockedRickAndMortyAPI.mockedEpisodeFileName))
        mockedCharactersAPIRepository.rickAndMortyEpisodesAPI = rickAndMortyEpisodesAPI
        
        // Set DBRepository response
        mockedCharactersDBRepository.episodes = fakeEpisodes
        
        do {
            // When
            let episode = try await testableObject.fetchEpisodes(ids: ids)
            
            // Then
            XCTAssertFalse(episode.isEmpty)
            XCTAssertEqual(episode.count, self.fakeEpisodes.count, "Receive \(episode.count) items instead of \(self.fakeEpisodes.count) items")
            self.mockedCharactersAPIRepository.verify()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}
