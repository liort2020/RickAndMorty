//
//  EpisodesAPI.swift
//  RickAndMorty
//
//  Created by Lior Tal on 30/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

protocol EpisodesAPI: Equatable {
    var id: Int { get }
    var name: String? { get }
    var airDate: String? { get }
    var episode: String? { get }
}
