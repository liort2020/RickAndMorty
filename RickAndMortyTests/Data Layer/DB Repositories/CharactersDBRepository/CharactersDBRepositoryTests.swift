//
//  CharactersDBRepositoryTests.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
import CoreData
@testable import RickAndMorty

final class CharactersDBRepositoryTests: XCTestCase {
    private var mockedPersistentStore = MockedPersistentStore()
    
    private var testableObject: RealCharactersDBRepository?
    
    // MARK: - setUp
    override func setUp() {
        super.setUp()
        mockedPersistentStore.inMemoryContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load store: \(error)")
            }
        }
        
        testableObject = RealCharactersDBRepository(persistentStore: mockedPersistentStore)
        mockedPersistentStore.verify()
    }
    
    func test_fetch_characters() async throws {
        let context = mockedPersistentStore.inMemoryContainer.viewContext
        let testableObject = try XCTUnwrap(testableObject)
        let rickAndMortyCharactersAPI: RickAndMortyCharactersAPI = try XCTUnwrap(MockedRickAndMortyAPI.load(fromResource: MockedRickAndMortyAPI.mockedOnlyOneCharacterFileName))
        let charactersAPI = try XCTUnwrap(rickAndMortyCharactersAPI.characters)

        // Given
        let fetchItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 0, updatedObjects: 0, deletedObjects: 0)
        mockedPersistentStore.actions = MockedList(expectedActions: [
            .fetch(fetchItemSnapshot)
        ])
                
        // Save items
        await save(items: charactersAPI, in: context)

        do {
            // When
            // Fetch items
            let characters = try await testableObject.fetchCharacters()

            // Then
            XCTAssertEqual(charactersAPI.count, characters.count, "Fetch \(characters.count) items instead of \(charactersAPI.count) items")
            self.mockedPersistentStore.verify()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_store_rickAndMortyCharactersAPI() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        let rickAndMortyCharactersAPI: RickAndMortyCharactersAPI = try XCTUnwrap(MockedRickAndMortyAPI.load(fromResource: MockedRickAndMortyAPI.mockedOnlyOneCharacterFileName))
        
        // Given
        let numberOfItems = 1
        let updateOneItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 1, updatedObjects: 0, deletedObjects: 0)
        let updateItemsSnapshot = Array(repeating: updateOneItemSnapshot, count: numberOfItems)
        let expectedActions = updateItemsSnapshot.map { MockedPersistentStore.Action.update($0) }
        mockedPersistentStore.actions = MockedList(expectedActions: expectedActions)
        
        do {
            // When
            let characters = try await testableObject.store(rickAndMortyCharactersAPI: rickAndMortyCharactersAPI)
            
            // Then
            XCTAssertEqual(numberOfItems, characters.count, "Store \(characters.count) items instead of \(numberOfItems) items")
            self.mockedPersistentStore.verify()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - tearDown
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}

// MARK: - save items for tests
fileprivate extension CharactersDBRepositoryTests {
    func save<Model>(items models: [Model], in context: NSManagedObjectContext) async where Model: CharactersAPI {
        return await context.perform {
            do {
                models.forEach {
                    $0.store(in: context)
                }
                
                guard context.hasChanges else {
                    XCTFail("Items not saved")
                    context.reset()
                    return
                }
                try context.save()
            } catch {
                XCTFail("Items not saved")
                context.reset()
            }
        }
    }
}
