//
//  CacheService.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import Foundation
import SwiftData

protocol CacheServiceProtocol {
    func save(events: [EventDTO]) async
    func loadEvents() -> [EventDTO]
}

final class CacheService: CacheServiceProtocol {
    private let container = try! ModelContainer(for: CachedEvent.self)
    private var context: ModelContext!

    
    @MainActor
    func save(events: [EventDTO]) async {
        context = container.mainContext
        
        for event in events {
            guard let imageData = event.image?.pngData() else { continue }
            
            let model = CachedEvent(event: event)
            
            context.insert(model)
        }
        
        try? context.save()
    }
    
    @MainActor
    func loadEvents() -> [EventDTO] {
        context = container.mainContext
        
        do {
            let results = try context.fetch(FetchDescriptor<CachedEvent>())
            
            return results.map { EventDTO(event: $0) }
        } catch {
            print("\(error)")
            return []
        }
    }
}
