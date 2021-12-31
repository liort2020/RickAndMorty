//
//  ConstantsTests.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import RickAndMorty

final class ConstantsTests: XCTestCase {
    private let baseURL = "https://rickandmortyapi.com/api"
    
    func test_baseURL() {
        XCTAssertEqual(Constants.baseURL, baseURL)
        XCTAssertNotEqual(Constants.baseURL.last, "/", "Added a backslash in the Endpoint enum")
    }
}
