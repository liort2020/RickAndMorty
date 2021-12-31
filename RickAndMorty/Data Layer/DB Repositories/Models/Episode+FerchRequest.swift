//
//  Episode+FerchRequest.swift
//  RickAndMorty
//
//  Created by Lior Tal on 30/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import CoreData

extension Episode {
    static let entityName = "Episode"
    
    static func requestAllItems() -> NSFetchRequest<Episode> {
        NSFetchRequest<Episode>(entityName: entityName)
    }
    
    static func requestItem(using id: Int) -> NSFetchRequest<Episode> {
        let request = NSFetchRequest<Episode>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %i", Int32(id))
        return request
    }
    
    static func requestItems(using ids: [Int]) -> NSFetchRequest<Episode> {
        let request = NSFetchRequest<Episode>(entityName: entityName)
        
        var predicates: [NSPredicate] = []
        ids.forEach { id in
            predicates.append(NSPredicate(format: "id == %i", Int32(id)))
        }
        request.predicate = NSCompoundPredicate(type: .or, subpredicates: predicates)
        return request
    }
}

// MARK: - Store
extension EpisodesAPI {
    @discardableResult
    func store(in context: NSManagedObjectContext) -> Episode {
        let episodeModel = Episode(context: context)
        episodeModel.id = Int32(id)
        episodeModel.name = name
        episodeModel.airDate = airDate
        episodeModel.episode = episode
        return episodeModel
    }
}
