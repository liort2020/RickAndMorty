//
//  CharactersAPI.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

protocol CharactersAPI: Equatable {
    var id: Int { get }
    var name: String? { get }
    var status: String? { get }
    var species: String? { get }
    var type: String? { get }
    var gender: String? { get }
    var image: String? { get }
    var episodesPath: [String]? { get }
}
