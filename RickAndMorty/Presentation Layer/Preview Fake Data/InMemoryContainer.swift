//
//  InMemoryContainer.swift
//  RickAndMorty
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation
import CoreData

#if DEBUG
struct InMemoryContainer {
    static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName)
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        return container
    }()
}
#endif
