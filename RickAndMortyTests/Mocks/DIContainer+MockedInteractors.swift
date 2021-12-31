//
//  DIContainer+MockedInteractors.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import RickAndMorty

extension DIContainer.Interactors {
    static func mocked(charactersInteractor: CharactersInteractor = MockedCharactersInteractor()) -> DIContainer.Interactors {
        DIContainer.Interactors(charactersInteractor: charactersInteractor)
    }
}
