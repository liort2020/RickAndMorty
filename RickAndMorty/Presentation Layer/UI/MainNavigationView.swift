//
//  MainNavigationView.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct MainNavigationView<ViewModel>: View where ViewModel: CharactersListViewModel {
    @Environment(\.inject) var diContainer: DIContainer
    @EnvironmentObject var charactersListViewModel: ViewModel
    
    var body: some View {
        NavigationView {
            // MARK: Main Screen
            MainView<RealCharactersListViewModel>()
                .environmentObject(charactersListViewModel)
                .navigationBarTitleDisplayMode(navigationTitleDisplayMode)
                .navigationTitle(navigationBarTitle)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .task {
            await loadCaractersList()
        }
    }
    
    // MARK: Constants
    // NavigationView
    private let navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode = .inline
    private let navigationBarTitle = "Rick and Morty"
}

// MARK: - Actions
extension MainNavigationView {
    private func loadCaractersList() async {
        await charactersListViewModel.load()
        await charactersListViewModel.fetchCharacters()
    }
}

// MARK: - Previews
struct MainNavigationView_Previews: PreviewProvider {
    private static let diContainer = DIContainer.boot()
    private static let charactersListViewModel = RealCharactersListViewModel(diContainer: Self.diContainer)
    
    static var previews: some View {
        Group {
            // preview light mode
            MainNavigationView<RealCharactersListViewModel>()
                .environmentObject(charactersListViewModel)
                .inject(diContainer)
                .preferredColorScheme(.light)
            
            // preview dark mode
            MainNavigationView<RealCharactersListViewModel>()
                .environmentObject(charactersListViewModel)
                .inject(diContainer)
                .preferredColorScheme(.dark)
            
            // preview right to left
            MainNavigationView<RealCharactersListViewModel>()
                .environmentObject(charactersListViewModel)
                .inject(diContainer)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
            
            // preview accessibility medium
            MainNavigationView<RealCharactersListViewModel>()
                .environmentObject(charactersListViewModel)
                .inject(diContainer)
                .environment(\.sizeCategory, .accessibilityMedium)
        }
    }
}

