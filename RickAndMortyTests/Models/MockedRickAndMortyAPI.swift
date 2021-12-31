//
//  MockedRickAndMortyAPI.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import RickAndMorty

class MockedRickAndMortyAPI {
    static var testBundle = Bundle(for: MockedRickAndMortyAPI.self)
    static let mockedCharacterFileName = "mock_character"
    static let mockedEpisodeFileName = "mock_episode"
    static let mockedOnlyOneCharacterFileName = "mock_only_one_character"
    
    static func load<Model>(fromResource fileName: String) -> Model? where Model: Codable {
        guard let url = testBundle.url(forResource: fileName, withExtension: "json") else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Model.self, from: data)
        } catch {
            print("An error occurred while loading a mock model: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func getData(fromResource fileName: String) -> Data? {
        guard let url = testBundle.url(forResource: fileName, withExtension: "json") else { return nil }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            print("An error occurred while loading a mock model: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func data(fromResource fileName: String) -> Data? {
        guard let url = testBundle.url(forResource: fileName, withExtension: "json") else { return nil }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            print("An error occurred while loading a mock model: \(error.localizedDescription)")
            return nil
        }
    }
}
