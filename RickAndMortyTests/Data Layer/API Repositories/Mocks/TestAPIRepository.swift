//
//  TestAPIRepository.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import RickAndMorty

class TestAPIRepository: APIRepository {
    static let testCharactersURL = "https://test.com"
    
    let session: URLSession = .mockedSession
    let baseURL = testCharactersURL
}
