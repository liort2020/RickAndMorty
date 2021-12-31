//
//  UIApplication+keyWindow.swift
//  RickAndMorty
//
//  Created by Lior Tal on 31/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

extension UIApplication {
    var keyWindow: UIWindow? {
        // Get connected scenes
        UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter {$0.activationState == .foregroundActive}
            // Keep only the first `UIWindowScene`
            .map {$0 as? UIWindowScene}
            .compactMap {$0}
            // Get its associated windows
            .first?.windows
            // Keep only the key window
            .filter {$0.isKeyWindow}.first
    }
}
