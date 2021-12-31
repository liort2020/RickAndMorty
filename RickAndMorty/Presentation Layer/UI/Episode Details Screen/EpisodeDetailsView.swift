//
//  EpisodeDetailsView.swift
//  RickAndMorty
//
//  Created by Lior Tal on 30/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

// MARK: Episode Details Screen
struct EpisodeDetailsView<ViewModel>: View where ViewModel: EpisodeDetailsViewModel {
    @ObservedObject var episodeDetailsViewModel: ViewModel
    
    var body: some View {
        VStack {
            Text(name)
                .font(nameTitleFont)
                .foregroundColor(nameTitleColor)
            
            Text(airDate)
                .font(airDateTextFont)
                .foregroundColor(airDateTextColor)
            
            Text(episodeTitle)
                .padding(.top, topEpisodeTextPadding)
        }
    }
    
    // MARK: Computed Properties
    private var episode: Episode {
        episodeDetailsViewModel.episode
    }
    
    private var name: String {
        episode.name ?? defaultEmptyTitle
    }
    
    private var airDate: String {
        episode.airDate ?? defaultEmptyTitle
    }
    
    private var episodeTitle: String {
        episode.episode ?? defaultEmptyTitle
    }
    
    // MARK: Constants
    private let defaultEmptyTitle = ""
    // Name Title
    private let nameTitleColor: Color = .primary
    private let nameTitleFont: Font = .system(size: 30, weight: .bold)
    // Air Date Text
    private let airDateTextColor: Color = .secondary
    private let airDateTextFont: Font = .system(size: 16, weight: .regular)
    // Episode Text
    private let topEpisodeTextPadding: CGFloat = 4
}

// MARK: - Previews
struct EpisodeDetailsView_Previews: PreviewProvider {
    private static let episodeDetailsViewModel = RealEpisodeDetailsViewModel(diContainer: DIContainer(), episode: FakeEpisodes.all[0])
    
    static var previews: some View {
        Group {
            // preview light mode
            EpisodeDetailsView(episodeDetailsViewModel: episodeDetailsViewModel)
                .preferredColorScheme(.light)
            
            // preview dark mode
            EpisodeDetailsView(episodeDetailsViewModel: episodeDetailsViewModel)
                .preferredColorScheme(.dark)
            
            // preview right to left
            EpisodeDetailsView(episodeDetailsViewModel: episodeDetailsViewModel)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
            
            // preview accessibility medium
            EpisodeDetailsView(episodeDetailsViewModel: episodeDetailsViewModel)
                .environment(\.sizeCategory, .accessibilityMedium)
        }
    }
}
