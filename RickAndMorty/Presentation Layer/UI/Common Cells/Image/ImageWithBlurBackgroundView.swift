//
//  ImageWithBlurBackgroundView.swift
//  RickAndMorty
//
//  Created by Lior Tal on 30/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct ImageWithBlurBackgroundView: View {
    var path: String?
    // Image
    var imageId: Int
    var imageWidth: CGFloat
    var imageHeight: CGFloat
    // Blur
    var blurRadius: CGFloat
    var blurImageContentMode: ContentMode
    var blurImageSize: CGFloat
    
    var body: some View {
        ZStack {
            // MARK: Blur Image
            ImageView(path: path,
                      imageId: imageId,
                      height: blurImageSize,
                      contentMode: blurImageContentMode)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: blurRadius)
            
            // MARK: Image
            HStack {
                Spacer()
                ImageView(path: path,
                          imageId: imageId,
                          width: imageWidth,
                          height: imageHeight,
                          contentMode: blurImageContentMode)
                Spacer()
            }
        }
    }
}

// MARK: - Previews
struct ImageWithBlurBackgroundView_Previews: PreviewProvider {
    // Image
    private static let imageId = 1
    private static let imageWidth: CGFloat = 150
    private static let imageHeight: CGFloat = 250
    // Blur Image
    private static let blurRadius: CGFloat = 50.0
    private static let blurImageContentMode: ContentMode = .fill
    private static let defaultBlurImageSize: CGFloat = 250
    
    static var previews: some View {
        Group {
            // preview light mode
            ImageWithBlurBackgroundView(imageId: Self.imageId,
                                        imageWidth: Self.imageWidth,
                                        imageHeight: Self.imageHeight,
                                        blurRadius: Self.blurRadius,
                                        blurImageContentMode: Self.blurImageContentMode,
                                        blurImageSize: Self.defaultBlurImageSize)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            // preview dark mode
            ImageWithBlurBackgroundView(imageId: Self.imageId,
                                        imageWidth: Self.imageWidth,
                                        imageHeight: Self.imageHeight,
                                        blurRadius: Self.blurRadius,
                                        blurImageContentMode: Self.blurImageContentMode,
                                        blurImageSize: Self.defaultBlurImageSize)                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
