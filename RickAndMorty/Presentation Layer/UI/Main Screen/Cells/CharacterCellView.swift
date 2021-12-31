//
//  CharacterCellView.swift
//  RickAndMorty
//
//  Created by Lior Tal on 30/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct CharacterCellView: View {
    let name: String?
    let image: String?
    let imageId: Int
    
    var body: some View {
        VStack {
            ImageView(path: image,
                      imageId: imageId)
                .frame(minWidth: 0, maxWidth: maxSize, minHeight: 0, maxHeight: maxSize)
            
            Text(name ?? defaultEmptyName)
                .foregroundColor(nameTitleColor)
                .padding(.bottom, nameTitleBottomPadding)
        }
    }
    
    // MARK: Constants
    // Name Text
    private let nameTitleColor: Color = .primary
    private let nameTitleBottomPadding: CGFloat = 5
    private let defaultEmptyName = ""
    // Image View
    private let maxSize: CGFloat = 200
}

// MARK: - Previews
struct CharacterCellView_Previews: PreviewProvider {
    private static let character = FakeCharacters.all[0]
    
    static var previews: some View {
        Group {
            // preview light mode
            CharacterCellView(name: character.name,
                              image: character.image,
                              imageId: Int(character.id))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            // preview dark mode
            CharacterCellView(name: character.name,
                              image: character.image,
                              imageId: Int(character.id))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
