//
//  APIRepositoryTests.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import RickAndMorty

final class APIRepositoryTests: XCTestCase {
    private var rickAndMortyEndpoint: RealCharactersAPIRepository.RickAndMortyEndpoint?
    
    private var testableObject: TestAPIRepository?
    
    override func setUp() {
        super.setUp()
        rickAndMortyEndpoint = RealCharactersAPIRepository.RickAndMortyEndpoint.getCharacters
        testableObject = TestAPIRepository()
    }
    
    func test_requestURL() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let expectedNumberOfItems = 20
        let page = 1
        let rickAndMortyEndpoint = try XCTUnwrap(rickAndMortyEndpoint)
        let data = try XCTUnwrap(MockedRickAndMortyAPI.getData(fromResource: MockedRickAndMortyAPI.mockedCharacterFileName))
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockAPIError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockAPIError.response }
            return (response, data)
        }
        
        do {
            // When
            let characters: RickAndMortyCharactersAPI = try await testableObject
                .requestURL(endpoint: rickAndMortyEndpoint, page: page)
            
            // Then
            XCTAssertNotNil(characters.characters)
            let numberOfItems = characters.characters?.count ?? 0
            XCTAssertEqual(numberOfItems, expectedNumberOfItems, "Receive \(numberOfItems) items instead of \(expectedNumberOfItems) items")
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_requestURL_apiError_invalidStatusCode() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let page = 1
        let invalidStatusCode = 199
        let rickAndMortyEndpoint = try XCTUnwrap(rickAndMortyEndpoint)
        let data = try XCTUnwrap(MockedRickAndMortyAPI.getData(fromResource: MockedRickAndMortyAPI.mockedCharacterFileName))
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockAPIError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: invalidStatusCode, httpVersion: nil, headerFields: nil) else { throw MockAPIError.response }
            return (response, data)
        }
        
        do {
            // When
            let _: RickAndMortyCharactersAPI = try await testableObject
                .requestURL(endpoint: rickAndMortyEndpoint, page: page)
            XCTFail("Expected to get a APIError")
        } catch {
            // Then
            XCTAssertEqual(error.localizedDescription, APIError.httpCode(HTTPError(code: invalidStatusCode)).localizedDescription, "Expected to get invalid status code, and got: \(error.localizedDescription)")
        }
    }
    
    override func tearDown() {
        rickAndMortyEndpoint = nil
        testableObject = nil
        super.tearDown()
    }
}
