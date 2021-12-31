//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    private let diContainer = DIContainer.boot()
    
    var body: some Scene {
        WindowGroup {
            MainNavigationView<RealCharactersListViewModel>()
                .environmentObject(RealCharactersListViewModel(diContainer: diContainer))
                .inject(diContainer)
        }
    }
}
