//
//  ImageView.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import URLImage

struct ImageView: View {
    var path: String?
    var imageId: Int
    var width: CGFloat?
    var height: CGFloat?
    var contentMode: ContentMode = .fit
    
    var body: some View {
        HStack {
            if let url =  url {
                URLImage(url: url,
                         options: URLImageOptions(identifier: id,
                                                  expireAfter: expireAfter,
                                                  cachePolicy: .returnCacheElseLoad(cacheDelay: nil, downloadDelay: downloadDelay)),
                         empty: {
                    emptyImageView(width: width, height: height, contentMode: contentMode)
                },
                         inProgress: { _ in
                    ZStack {
                        emptyImageView(width: width, height: height, contentMode: contentMode)
                        ActivityIndicator()
                    }
                },
                         failure: { _, _ in
                    emptyImageView(width: width, height: height, contentMode: contentMode)
                },
                         content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .clipped()
                })
            } else {
                emptyImageView(width: width, height: height, contentMode: contentMode)
            }
        }
        .frame(width: width, height: height)
    }
    
    // MARK: Computed Properties
    private var id: String {
        "\(imageId)"
    }
    
    private var url: URL? {
        guard let path = path, let url = URL(string: path) else { return nil }
        return url
    }
    
    private func emptyImageView(width: CGFloat? = nil, height: CGFloat? = nil, contentMode: ContentMode = .fit) -> some View {
        EmptyImageView(width: width, height: height, contentMode: contentMode)
    }
    
    // MARK: Constants
    private let expireAfter: TimeInterval = 24 * 60 * 60 // 86,400 second = 24 hours
    private let downloadDelay: TimeInterval = 0.25
}
