//
//  MainView.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

// MARK: Main Screen
struct MainView<ViewModel>: View where ViewModel: CharactersListViewModel {
    @EnvironmentObject var charactersListViewModel: ViewModel
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            if isCharactersListLoaded && !isEmptyCharacterListSearch {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: gridSpacing) {
                        ForEach(searchCharacters) { character in
                            NavigationLink(
                                destination: characterDetailsView(character: character),
                                tag: character,
                                selection: $charactersListViewModel.routing.characterDetails,
                                label: {
                                    CharacterCellView(name: character.name,
                                                      image: character.image,
                                                      imageId: Int(character.id))
                                })
                                .buttonStyle(PlainButtonStyle())
                        }
                        // MARK: Pagination cell
                        ProgressCellView()
                            .task {
                                await fetchCharacters()
                            }
                    }
                }
            } else if isCharactersListEmpty {
                VStack {
                    Spacer()
                    EmptyTextView(emptyTitle: emptyListTitle)
                        .padding(.bottom, bottomEmptyCellViewPadding)
                    Spacer()
                }
            } else if isLoadedAndEmptyCharacterListSearch {
                VStack {
                    Spacer()
                    EmptyTextView(emptyTitle: emptySearchTitle)
                        .padding(.bottom, bottomEmptyCellViewPadding)
                    Spacer()
                }
            } else {
                EmptyView()
            }
        }
        .searchable(text: $searchText, placement: alwaysShowSearchBar, prompt: searchCharacterNamePlaceholder)
    }
    
    // MARK: Computed Properties
    private var columns: [GridItem] {
        Array(repeating: .init(.flexible()), count: numberOfColumns)
    }
    
    private var characters: [Character] {
        charactersListViewModel.characters
    }
    
    private var isCharactersListLoaded: Bool {
        return !charactersListViewModel.isLoading && !characters.isEmpty
    }
    
    private var isCharactersListEmpty: Bool {
        !charactersListViewModel.isLoading && characters.isEmpty
    }
    
    private var isLoadedAndEmptyCharacterListSearch: Bool {
        !charactersListViewModel.isLoading && searchCharacters.isEmpty
    }
    
    private var isEmptyCharacterListSearch: Bool {
        searchCharacters.isEmpty
    }
    
    // MARK: Constants
    // Grid
    private let numberOfColumns = 2
    private let gridHorizontalPagging: Edge.Set = .horizontal
    private let gridSpacing: CGFloat = 10
    private let cellSize: CGFloat = 200
    // Empty Cell
    private let bottomEmptyCellViewPadding: CGFloat = 150
    private let emptyListTitle = "No Data Available"
    private let emptySearchTitle = "No Data Found"
    // Search
    private let alwaysShowSearchBar: SearchFieldPlacement = .navigationBarDrawer(displayMode: .always)
    private let searchCharacterNamePlaceholder = "Search Character Name"
}

// MARK: - Actions
extension MainView {
    private func fetchCharacters() async {
        await charactersListViewModel.fetchCharacters()
    }
}

// MARK: - Navigation
extension MainView {
    private var diContainer: DIContainer {
        charactersListViewModel.diContainer
    }
    
    func characterDetailsView(character: Character) -> some View {
        CharacterDetailsView(characterDetailsViewModel: RealCharacterDetailsViewModel(diContainer: diContainer, character: character))
    }
}

// MARK: - Search
extension MainView {
    var searchCharacters: [Character] {
        if searchText.isEmpty {
            return characters
        } else {
            return characters.filter {
                guard let name = $0.name else { return false }
                return name.contains(searchText)
            }
        }
    }
}

// MARK: - Previews
struct MainView_Previews: PreviewProvider {
    private static let fakeRealCharactersListViewModel = RealCharactersListViewModel(diContainer: DIContainer(), characters: FakeCharacters.all, isLoading: false)
    
    static var previews: some View {
        // MARK: With characters
        // preview light mode
        MainView<RealCharactersListViewModel>()
            .environmentObject(fakeRealCharactersListViewModel)
            .preferredColorScheme(.light)
        
        // preview dark mode
        MainView<RealCharactersListViewModel>()
            .environmentObject(fakeRealCharactersListViewModel)
            .preferredColorScheme(.dark)
        
        // preview right to left
        MainView<RealCharactersListViewModel>()
            .environmentObject(fakeRealCharactersListViewModel)
            .environment(\.layoutDirection, .rightToLeft)
            .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
        
        // preview accessibility medium
        MainView<RealCharactersListViewModel>()
            .environmentObject(fakeRealCharactersListViewModel)
            .environment(\.sizeCategory, .accessibilityMedium)
    }
}
