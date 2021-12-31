//
//  CharacterDetailsViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 31/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import RickAndMorty

final class CharacterDetailsViewModelTests: XCTestCase {
    private let appState = CurrentValueSubject<AppState, Never>(AppState())
    private lazy var mockedCharactersInteractor = MockedCharactersInteractor()
    private lazy var diContainer: DIContainer = {
        DIContainer.init(appState: appState,
                         interactors: .mocked(charactersInteractor: mockedCharactersInteractor))
    }()
    private lazy var fakeCharacter = FakeCharacters.all[0]
    private lazy var fakeEpisodes = FakeEpisodes.all
    private lazy var isLoading = false
    
    var testableObject: RealCharacterDetailsViewModel?
    
    override func setUp() {
        super.setUp()
        appState.value = AppState()
        testableObject = RealCharacterDetailsViewModel(diContainer: diContainer,
                                                       character: fakeCharacter,
                                                       isLoading: isLoading)
    }
    
    func loadEpisodes() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let ids = fakeEpisodes.map { Int($0.id) }
        mockedCharactersInteractor.actions = MockedList(expectedActions: [
            .loadEpisodes(ids: ids)
        ])
        
        // When
        await testableObject.loadEpisodes()
        
        // Then
        mockedCharactersInteractor.verify()
    }
    
    func fetchEpisodes() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let ids = fakeEpisodes.map { Int($0.id) }
        mockedCharactersInteractor.actions = MockedList(expectedActions: [
            .fetchEpisodes(ids: ids)
        ])
        
        // When
        await testableObject.fetchEpisodes()
        
        // Then
        mockedCharactersInteractor.verify()
    }
    
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}
