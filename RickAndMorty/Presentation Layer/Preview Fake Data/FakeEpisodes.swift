//
//  FakeEpisodes.swift
//  RickAndMorty
//
//  Created by Lior Tal on 31/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

#if DEBUG
struct FakeEpisodes {
    private static func createFakeEpisode(id: Int, name: String, airDate: String, seasonEpisode: String) -> Episode {
        let episode = Episode(context: InMemoryContainer.container.viewContext)
        episode.id = Int32(id)
        episode.name = name
        episode.airDate = airDate
        episode.episode = seasonEpisode
        return episode
    }
    
    static var all: [Episode] {
        [
            createFakeEpisode(id: 1,
                              name: "Pilot",
                              airDate: "December 2, 2013",
                              seasonEpisode: "S01E01"),
            createFakeEpisode(id: 2,
                              name: "Lawnmower Dog",
                              airDate: "December 9, 2013",
                              seasonEpisode: "S01E02"),
            createFakeEpisode(id: 3,
                              name: "Anatomy Park",
                              airDate: "December 16, 2013",
                              seasonEpisode: "S01E03"),
            createFakeEpisode(id: 4,
                              name: "M. Night Shaym-Aliens!",
                              airDate: "January 13, 2014",
                              seasonEpisode: "S01E04"),
            createFakeEpisode(id: 5,
                              name: "Meeseeks and Destro",
                              airDate: "January 20, 2014",
                              seasonEpisode: "S01E05"),
            createFakeEpisode(id: 6,
                              name: "Rick Potion #9",
                              airDate: "January 27, 2014",
                              seasonEpisode: "S01E06")
        ]
    }
}
#endif
