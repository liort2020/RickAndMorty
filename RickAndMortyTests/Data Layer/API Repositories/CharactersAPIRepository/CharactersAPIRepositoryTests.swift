//
//  CharactersAPIRepositoryTests.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
import CoreData
@testable import RickAndMorty

final class CharactersAPIRepositoryTests: XCTestCase {
    private let baseURL = TestAPIRepository.testCharactersURL
    
    private var testableObject: RealCharactersAPIRepository?
    
    override func setUp() {
        super.setUp()
        testableObject = RealCharactersAPIRepository(session: .mockedSession, baseURL: baseURL)
    }
    
    func test_getCharacters() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let expectedNumberOfItems = 20
        let page = 1
        let data = try XCTUnwrap(MockedRickAndMortyAPI.getData(fromResource: MockedRickAndMortyAPI.mockedCharacterFileName))
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockAPIError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockAPIError.response }
            return (response, data)
        }
        
        do {
            // When
            let characters: RickAndMortyCharactersAPI = try await testableObject.getCharacters(page: page)
            
            // Then
            XCTAssertNotNil(characters.characters)
            let numberOfCharacters = characters.characters?.count ?? 0
            XCTAssertEqual(numberOfCharacters, expectedNumberOfItems, "Receive \(numberOfCharacters) items instead of \(expectedNumberOfItems) items")
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}
