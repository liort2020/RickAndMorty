//
//  CharactersListViewModel+UserDefaults.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

extension RealCharactersListViewModel {
    enum UserDefaultsKeys: String {
        case currentPage
    }
    
    private static var defaultCurrentPage = 1
    
    var currentPage: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.currentPage.rawValue)
        }
        get {
            // check if value exists
            guard UserDefaults.standard.object(forKey: UserDefaultsKeys.currentPage.rawValue) != nil else {
                // Set default value
                UserDefaults.standard.set(Self.defaultCurrentPage, forKey: UserDefaultsKeys.currentPage.rawValue)
                return UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentPage.rawValue)
            }
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentPage.rawValue)
        }
    }
}
