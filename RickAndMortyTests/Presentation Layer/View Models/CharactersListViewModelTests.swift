//
//  CharactersListViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 31/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import RickAndMorty

final class CharactersListViewModelTests: XCTestCase {
    private let appState = CurrentValueSubject<AppState, Never>(AppState())
    private lazy var mockedCharactersInteractor = MockedCharactersInteractor()
    private lazy var diContainer: DIContainer = {
        DIContainer.init(appState: appState,
                         interactors: .mocked(charactersInteractor: mockedCharactersInteractor))
    }()
    private lazy var fakeCharacters = FakeCharacters.all
    private lazy var isLoading = false
    
    var testableObject: RealCharactersListViewModel?
    
    override func setUp() {
        super.setUp()
        appState.value = AppState()
        testableObject = RealCharactersListViewModel(diContainer: diContainer,
                                                     characters: fakeCharacters,
                                                     isLoading: isLoading)
    }
    
    func test_load() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        mockedCharactersInteractor.actions = MockedList(expectedActions: [
            .loadCharacters
        ])
        
        // When
        await testableObject.load()
        
        // Then
        mockedCharactersInteractor.verify()
    }
    
    func test_fetchCharacters() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let page = testableObject.currentPage
        mockedCharactersInteractor.actions = MockedList(expectedActions: [
            .fetchCharacters(page: page)
        ])
        
        // When
        await testableObject.fetchCharacters()
        
        // Then
        mockedCharactersInteractor.verify()
    }
    
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}
