//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Lior Tal on 30/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

// MARK: Character Details Screen
struct CharacterDetailsView<ViewModel>: View where ViewModel: CharacterDetailsViewModel {
    @ObservedObject var characterDetailsViewModel: ViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                VStack {
                    // MARK: Image
                    ImageWithBlurBackgroundView(path: character.image,
                                                imageId: characterId,
                                                imageWidth: characterImageWidth,
                                                imageHeight: characterImageHeight,
                                                blurRadius: blurRadius,
                                                blurImageContentMode: blurImageContentMode,
                                                blurImageSize: defaultBlurImageSize)
                        .edgesIgnoringSafeArea(.horizontal)
                    
                    // MARK: Name
                    Text(name)
                        .font(nameTitleFont)
                        .foregroundColor(nameTitleColor)
                        .padding(nameTitlePadding)
                    
                    // MARK: Gender, Status, Species container
                    HStack {
                        Text(gender)
                        Divider()
                        Text(status)
                        Divider()
                        Text(species)
                    }
                    .font(titlesContainerFont)
                    .foregroundColor(titlesContainerColor)
                    .frame(height: titlesContainerHeight)
                }
                
                // MARK: Episodes List
                if isEpisodeListLoaded {
                    VStack(alignment: .leading) {
                        Section(header: Text(episodeHeaderTitle)
                                    .font(episodeTitleFont)
                                    .foregroundColor(episodeTitleColor)
                                    .padding(episodeTitlePadding)) {
                            ForEach(episodes) { episode in
                                NavigationLink(
                                    destination: episodeDetailsView(episode: episode),
                                    tag: episode,
                                    selection: $characterDetailsViewModel.routing.episodeDetails,
                                    label: {
                                        Text(episode.episode ?? defaultEmptyTitle)
                                            .font(episodeTitleFont)
                                            .foregroundColor(episodeTitleColor)
                                            .padding(episodeTitlePadding)
                                    })
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, episodesListPadding)
                } else {
                    Spacer()
                }
            }
        }
        .navigationBarItems(trailing: shareButtonView())
        .task {
            if !isEpisodeListLoaded {
                await loadEpisodeList()
            }
        }
    }
    
    // MARK: Computed Properties
    private var character: Character {
        characterDetailsViewModel.character
    }
    
    private var episodes: [Episode] {
        characterDetailsViewModel.episodes.filter { $0.name != nil }
    }
    
    private var name: String {
        character.name ?? defaultEmptyTitle
    }
    
    private var gender: String {
        character.gender ?? defaultEmptyTitle
    }
    
    private var status: String {
        character.status ?? defaultEmptyTitle
    }
    
    private var species: String {
        character.species ?? defaultEmptyTitle
    }
    
    private var type: String {
        character.type ?? defaultEmptyTitle
    }
    
    private var characterId: Int {
        Int(character.id)
    }
    
    private var isEpisodeListLoaded: Bool {
        !characterDetailsViewModel.isLoading && !episodes.isEmpty
    }
    
    // MARK: Constants
    private let defaultEmptyTitle = ""
    // Character Image
    private let characterImageWidth: CGFloat = 100
    private let characterImageHeight: CGFloat = 150
    // Character Image Blur
    private let blurRadius: CGFloat = 50.0
    private let blurImageContentMode: ContentMode = .fill
    private let defaultBlurImageSize: CGFloat = 150
    // Name Title
    private let nameTitleColor: Color = .primary
    private let nameTitleFont: Font = .system(size: 30, weight: .bold)
    private let nameTitlePadding: CGFloat = 4
    // Episodes List
    private let episodesListPadding: CGFloat = 15
    // Episode Header
    private let episodeHeaderTitle = "Episodes"
    // Episode Title
    private let episodeTitleColor: Color = .primary
    private let episodeTitleFont: Font = .system(size: 20, weight: .medium)
    private let episodeTitlePadding: CGFloat = 4
    // Titles Container
    private let titlesContainerColor: Color = .secondary
    private let titlesContainerFont: Font = .system(size: 16, weight: .regular)
    private let titlesContainerHeight: CGFloat = 30
}

// MARK: - Navigation
extension CharacterDetailsView {
    private var diContainer: DIContainer {
        characterDetailsViewModel.diContainer
    }
    
    func episodeDetailsView(episode: Episode) -> some View {
        EpisodeDetailsView(episodeDetailsViewModel: RealEpisodeDetailsViewModel(diContainer: diContainer, episode: episode))
    }
}

// MARK: - Actions
extension CharacterDetailsView {
    private func loadEpisodeList() async {
        await characterDetailsViewModel.fetchEpisodes()
    }
}

// MARK: - Share Bar Button Item
extension CharacterDetailsView {
    private func shareButtonView() -> some View {
        ShareButtonView(imagePath: character.image)
    }
}

// MARK: - Previews
struct CharacterDetailsView_Previews: PreviewProvider {
    private static let characterDetailsViewModel = RealCharacterDetailsViewModel(diContainer: DIContainer(), character: FakeCharacters.all[0])
    
    static var previews: some View {
        Group {
            // preview light mode
            CharacterDetailsView(characterDetailsViewModel: characterDetailsViewModel)
                .preferredColorScheme(.light)
            
            // preview dark mode
            CharacterDetailsView(characterDetailsViewModel: characterDetailsViewModel)
                .preferredColorScheme(.dark)
            
            // preview right to left
            CharacterDetailsView(characterDetailsViewModel: characterDetailsViewModel)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
            
            // preview accessibility medium
            CharacterDetailsView(characterDetailsViewModel: characterDetailsViewModel)
                .environment(\.sizeCategory, .accessibilityMedium)
            
        }
    }
}
