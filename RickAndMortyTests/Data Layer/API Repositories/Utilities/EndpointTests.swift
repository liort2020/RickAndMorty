//
//  EndpointTests.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import RickAndMorty

final class EndpointTests: XCTestCase {
    private var testURL = TestAPIRepository.testCharactersURL
    
    func test_getCharacters() throws {
        // Given
        let testableObject = try XCTUnwrap(RealCharactersAPIRepository.RickAndMortyEndpoint.getCharacters)
        
        do {
            // When
            let urlRequest = try testableObject.request(url: testURL)
            
            // Then
            XCTAssertNotNil(urlRequest)
            // path
            let request = try XCTUnwrap(urlRequest)
            XCTAssertNotNil(request.url)
            // query parameters
            XCTAssertNil(request.url?.query)
            // method
            XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
            // headers
            XCTAssertEqual(request.allHTTPHeaderFields, ["Content-Type": "application/json"])
            // body
            XCTAssertNil(request.httpBody)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
}
