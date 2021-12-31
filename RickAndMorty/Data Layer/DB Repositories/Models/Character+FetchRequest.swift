//
//  Character+FetchRequest.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import CoreData

extension Character {
    static let entityName = "Character"
    
    static func requestAllItems() -> NSFetchRequest<Character> {
        let request = NSFetchRequest<Character>(entityName: entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return request
    }
    
    static func requestItem(using id: Int) -> NSFetchRequest<Character> {
        let request = NSFetchRequest<Character>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %i", Int32(id))
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return request
    }
    
    func getEpisodesSortedById() -> [Episode] {
        guard let episodesSet = episodes as? Set<Episode>,
              let episodes = episodesSet.compactMap({ ($0 as AnyObject) }) as? [Episode]
        else { return [] }
        
        return episodes.sorted(by: { $0.id < $1.id })
    }
    
    func getEpisodesIds() -> [Int] {
        let episodes = getEpisodesSortedById()
        return episodes.map {
            Int($0.id)
        }
    }
}

// MARK: - Store
extension CharactersAPI {
    @discardableResult
    func store(in context: NSManagedObjectContext) -> Character {
        let character = Character(context: context)
        character.id = Int32(id)
        character.name = name
        character.status = status
        character.species = species
        character.type = type
        character.gender = gender
        character.image = image
        episodesPath?.forEach { episodePath in
            guard let id = URL(string: episodePath)?.lastPathComponent,
                  let episodeId = Int32(id)
            else { return }
            
            let episode = Episode(context: context)
            episode.id = episodeId
            character.addToEpisodes(episode)
        }
        return character
    }
}
