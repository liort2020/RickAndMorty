//
//  DIContainer.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import Combine

typealias AppStateSubject = CurrentValueSubject<AppState, Never>

struct DIContainer {
    private(set) var appState: AppStateSubject?
    private(set) var interactors: Interactors?
    
    static func boot() -> DIContainer {
        let appState = CurrentValueSubject<AppState, Never>(AppState())
        
        let session = URLSession.shared
        let apiRepositories = configureAPIRepositories(using: session)
        let dbRepositories = configureDBRepositories()
        let interactors = configureInteractors(apiRepositories: apiRepositories, dbRepositories: dbRepositories, appState: appState)
        
        return DIContainer(appState: appState, interactors: interactors)
    }
    
    private static func configureAPIRepositories(using session: URLSession) -> DIContainer.APIRepositories {
        let charactersAPIRepository = RealCharactersAPIRepository(session: session, baseURL: Constants.baseURL)
        return DIContainer.APIRepositories(charactersAPIRepository: charactersAPIRepository)
    }
    
    private static func configureDBRepositories() -> DIContainer.DBRepositories {
        let persistentStore = CoreDataStack()
        let charactersDBRepository = RealCharactersDBRepository(persistentStore: persistentStore)
        return DIContainer.DBRepositories(charactersDBRepository: charactersDBRepository)
    }
    
    private static func configureInteractors(apiRepositories: DIContainer.APIRepositories, dbRepositories: DIContainer.DBRepositories, appState: AppStateSubject) -> DIContainer.Interactors {
        let charactersAPIRepository: CharactersAPIRepository = apiRepositories.charactersAPIRepository
        
        let charactersInteractor = RealCharactersInteractor(charactersAPIRepository: charactersAPIRepository,
                                                            charactersDBRepository: dbRepositories.charactersDBRepository,
                                                            appState: appState)
        return DIContainer.Interactors(charactersInteractor: charactersInteractor)
    }
}
