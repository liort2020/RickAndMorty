//
//  AppState.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct AppState {
    var routing = ViewRouting()
}

extension AppState {
    struct ViewRouting {
        var charactersList = CharactersListViewRouting()
        var characterDetails = CharacterDetailsViewRouting()
        var episodeDetails = EpisodeDetailsViewRouting()
    }
}
