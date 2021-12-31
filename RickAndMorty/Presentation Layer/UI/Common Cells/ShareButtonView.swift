//
//  ShareButtonView.swift
//  RickAndMorty
//
//  Created by Lior Tal on 31/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct ShareButtonView: View {
    let imagePath: String?
    
    var body: some View {
        if imageURL != nil {
            Button(action: showShareSheet) {
                Image(systemName: shareSystemImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
    
    // MARK: Computed Properties
    var imageURL: URL? {
        guard let imagePath = imagePath,
              !imagePath.isEmpty,
              let imageShareURL = URL(string: imagePath)
        else { return nil }
        return imageShareURL
    }
    
    // MARK: Constants
    private let shareSystemImageName = "square.and.arrow.up"
    
}

// MARK: - Action
extension ShareButtonView {
    private func showShareSheet() {
        guard let imageURL = imageURL else { return }
        
        let activityVC = UIActivityViewController(activityItems: [imageURL], applicationActivities: nil)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

// MARK: - Previews
struct ShareButtonView_Previews: PreviewProvider {
    private static let imagePath = "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
    
    static var previews: some View {
        Group {
            // preview light mode
            ShareButtonView(imagePath: imagePath)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            // preview dark mode
            ShareButtonView(imagePath: imagePath)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
