//
//  FakeCharacters.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

#if DEBUG
struct FakeCharacters {
    private static func createFakeCharacter(id: Int, name: String, status: String, species: String, type: String, gender: String, image: String) -> Character {
        let character = Character(context: InMemoryContainer.container.viewContext)
        character.id = Int32(id)
        character.name = name
        character.status = status
        character.species = species
        character.type = type
        character.gender = gender
        character.image = image
        return character
    }
    
    static var all: [Character] {
        [
            createFakeCharacter(id: 1,
                                name: "Rick Sanchez",
                                status: "Alive",
                                species: "Human",
                                type: "",
                                gender: "Male",
                                image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"),
            createFakeCharacter(id: 2,
                                name: "Morty Smith",
                                status: "Alive",
                                species: "Human",
                                type: "",
                                gender: "Male",
                                image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg"),
            createFakeCharacter(id: 3,
                                name: "Summer Smith",
                                status: "Alive",
                                species: "Human",
                                type: "",
                                gender: "Female",
                                image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg"),
            createFakeCharacter(id: 4,
                                name: "Beth Smith",
                                status: "Alive",
                                species: "Human",
                                type: "",
                                gender: "Female",
                                image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg"),
            createFakeCharacter(id: 5,
                                name: "Jerry Smith",
                                status: "Alive",
                                species: "Human",
                                type: "",
                                gender: "Male",
                                image: "https://rickandmortyapi.com/api/character/avatar/5.jpeg"),
            createFakeCharacter(id: 6,
                                name: "Abadango Cluster Princess",
                                status: "Alive",
                                species: "Alien",
                                type: "",
                                gender: "Female",
                                image: "https://rickandmortyapi.com/api/character/avatar/6.jpeg")
        ]
    }
}
#endif
