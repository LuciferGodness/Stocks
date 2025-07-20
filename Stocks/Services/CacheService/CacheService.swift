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
    func add<T: Cacheable>(_ item: T) async
    func remove<T: Cacheable>(_ item: T) async
    func isFavorite<T: Cacheable>(_ item: T) -> Bool
}

final class CacheService: CacheServiceProtocol {
    private let container: ModelContainer
    private var context: ModelContext!
    
    init() {
        self.container = try! ModelContainer(for: FavouriteStock.self)
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
    
    @MainActor
    func add<T: Cacheable>(_ item: T) async {
        self.context = container.mainContext
        let model = item.toManagedObject()
        context.insert(model)
        try? context.save()
    }
    
    @MainActor
    func remove<T: Cacheable>(_ item: T) async {
        self.context = container.mainContext
        // We need a way to uniquely identify the object to delete.
        // Assuming symbol is unique for stocks.
        guard let symbol = (item as? StocksDTO)?.symbol else { return }
        
        do {
            let predicate = #Predicate<FavouriteStock> { $0.symbol == symbol }
            let descriptor = FetchDescriptor<FavouriteStock>(predicate: predicate)
            if let objectToDelete = try context.fetch(descriptor).first {
                context.delete(objectToDelete)
                try? context.save()
            }
        } catch {
            print("Failed to remove item: \(error)")
        }
    }
    
    @MainActor
    func isFavorite<T: Cacheable>(_ item: T) -> Bool {
        self.context = container.mainContext
        guard let symbol = (item as? StocksDTO)?.symbol else { return false }
        
        do {
            let predicate = #Predicate<FavouriteStock> { $0.symbol == symbol }
            let descriptor = FetchDescriptor<FavouriteStock>(predicate: predicate)
            let count = try context.fetchCount(descriptor)
            return count > 0
        } catch {
            print("Failed to check favorite status: \(error)")
            return false
        }
    }
//    self.context = container.mainContext
//    do {
//        let results = try context.fetch(FetchDescriptor<T.ManagedModel>())
//        
//        return results.map { $0.toDTO() }
//    } catch {
//        print("\(error)")
//        return []
//    }
}

