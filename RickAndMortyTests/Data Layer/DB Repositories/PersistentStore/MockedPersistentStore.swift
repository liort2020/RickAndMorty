//
//  MockedPersistentStore.swift
//  RickAndMortyTests
//
//  Created by Lior Tal on 29/12/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import CoreData
import Combine
@testable import RickAndMorty

final class MockedPersistentStore: Mock {
    // PersistentStore context snapshot
    struct Snapshot: Equatable {
        let insertedObjects: Int
        let updatedObjects: Int
        let deletedObjects: Int
    }
    
    enum Action: Equatable {
        case fetch(Snapshot)
        case update(Snapshot)
        case delete(Snapshot)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    lazy var inMemoryContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName)
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        return container
    }()
    
}

extension MockedPersistentStore: PersistentStore {
    func fetch<Item>(_ fetchRequest: NSFetchRequest<Item>) async throws -> [Item] {
        let context = inMemoryContainer.viewContext
        context.reset()
        
        return try await context.perform {
            do {
                let resultItems = try context.fetch(fetchRequest)
                if Item.self is Character.Type {
                    self.add(.fetch(context.snapshot))
                } else {
                    fatalError("Currently, we do not support \(Item.self) for tests")
                }
                try context.save()
                return resultItems
            } catch let error {
                context.reset()
                throw PersistentStoreError.unknown(error: error.localizedDescription)
            }
        }
    }
    
    func update<Item>(fetchRequest: NSFetchRequest<Item>, update: @escaping (Item) -> Void, createNew: @escaping (NSManagedObjectContext) -> Item) async throws -> Item {
        let context = inMemoryContainer.viewContext
        context.reset()
        
        return try await context.perform {
            do {
                var resultItem: Item
                if let itemsToUpdate = try context.fetch(fetchRequest).first {
                    update(itemsToUpdate)
                    resultItem = itemsToUpdate
                    self.add(.update(context.snapshot))
                } else {
                    resultItem = createNew(context)
                    self.add(.update(context.snapshot))
                }
                try context.save()
                return resultItem
            } catch {
                context.reset()
                throw PersistentStoreError.unknown(error: error.localizedDescription)
            }
        }
    }
    
    func delete<Item: NSManagedObject>(_ fetchRequest: NSFetchRequest<Item>) async throws -> Void {
        let context = inMemoryContainer.viewContext
        
        try await context.perform {
            do {
                let itemsToDelete = try context.fetch(fetchRequest)
                itemsToDelete.forEach {
                    context.delete($0)
                    self.add(.delete(context.snapshot))
                }
                
                guard context.hasChanges else {
                    context.reset()
                    return
                }
                try context.save()
            } catch {
                context.reset()
                throw PersistentStoreError.unknown(error: error.localizedDescription)
            }
        }
    }
}

fileprivate extension NSManagedObjectContext {
    var snapshot: MockedPersistentStore.Snapshot {
        MockedPersistentStore.Snapshot(insertedObjects: insertedObjects.count,
                                       updatedObjects: updatedObjects.count,
                                       deletedObjects: deletedObjects.count)
    }
}
