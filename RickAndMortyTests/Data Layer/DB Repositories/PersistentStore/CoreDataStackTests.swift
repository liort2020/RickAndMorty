//
//  CoreDataStackTests.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import RickAndMorty

final class CoreDataStackTests: XCTestCase {
    private var testableObject: CoreDataStack?
    
    override func setUp() {
        super.setUp()
        testableObject = CoreDataStack()
    }
    
    func test_fetch() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let fetchRequest = Character.requestAllItems()
        
        do {
            // When
            let _ = try await testableObject.fetch(fetchRequest)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_createNewOrUpdate() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let rickAndMortyCharactersAPI: RickAndMortyCharactersAPI = try XCTUnwrap(MockedRickAndMortyAPI.load(fromResource: MockedRickAndMortyAPI.mockedCharacterFileName))
        let characterAPI = try XCTUnwrap(rickAndMortyCharactersAPI.characters?.first)
        
        let testItemId = Int32.random(in: 1..<Int32.max)
        let fetchRequest = Character.requestItem(using: Int(testItemId))
        
        do {
            // When
            let character = try await testableObject
                .update(fetchRequest: fetchRequest) { item in
                    item.name = characterAPI.name
                    item.status = characterAPI.status
                    item.species = characterAPI.species
                    item.type = characterAPI.type
                    item.gender = characterAPI.gender
                    item.image = characterAPI.image
                } createNew: { context in
                    characterAPI.store(in: context)
                }
            
            // Then
            XCTAssertNotNil(character.id)
            XCTAssertEqual(character.name, characterAPI.name)
            XCTAssertEqual(character.status, characterAPI.status)
            XCTAssertEqual(character.species, characterAPI.species)
            XCTAssertEqual(character.type, characterAPI.type)
            XCTAssertEqual(character.gender, characterAPI.gender)
            XCTAssertEqual(character.image, characterAPI.image)
            XCTAssertEqual(character.name, characterAPI.name)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_delete() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let id = 100
        let fetchRequest = Character.requestItem(using: id)
        
        do {
            // When
            try await testableObject.delete(fetchRequest)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}
