//
//  CacheService.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import Foundation
import SwiftData

protocol CacheServiceProtocol {
    func save<T: Cacheable>(_ items: [T]) async
    func load<T: Cacheable>() -> [T]
}

final class CacheService: CacheServiceProtocol {
    private let container: ModelContainer
    private var context: ModelContext!

    init() {
        self.container = try! ModelContainer(for: CachedEvent.self, CachedEventDetails.self)
    }

    @MainActor
    func save<T: Cacheable>(_ items: [T]) async {
        self.context = container.mainContext
        for item in items {
            let model = item.toManagedObject()
            context.insert(model)
        }
        
        try? context.save()
    }
    
    @MainActor
    func load<T: Cacheable>() -> [T] {
        self.context = container.mainContext
        do {
            let results = try context.fetch(FetchDescriptor<T.ManagedModel>())
            
            return results.map { $0.toDTO() }
        } catch {
            print("\(error)")
            return []
        }
    }
}
