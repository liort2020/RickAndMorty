//
//  EpisodeDetailsViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 31/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import RickAndMorty

final class EpisodeDetailsViewModelTests: XCTestCase {
    private let appState = CurrentValueSubject<AppState, Never>(AppState())
    private lazy var mockedCharactersInteractor = MockedCharactersInteractor()
    private lazy var diContainer: DIContainer = {
        DIContainer.init(appState: appState,
                         interactors: .mocked(charactersInteractor: mockedCharactersInteractor))
    }()
    private lazy var fakeEpisode = FakeEpisodes.all[0]
    private lazy var isLoading = false
    
    var testableObject: RealEpisodeDetailsViewModel?
    
    override func setUp() {
        super.setUp()
        appState.value = AppState()
        testableObject = RealEpisodeDetailsViewModel(diContainer: diContainer,
                                                     episode: fakeEpisode)
    }
    
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}
