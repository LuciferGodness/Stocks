//
//  CacheService.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import Foundation
import SwiftData

protocol CacheServiceProtocol {
    func save(events: [EventDTO])
    func loadEvents() -> [EventDTO]
}

@MainActor
final class CacheService: CacheServiceProtocol {
    private let container = try! ModelContainer(for: CachedEvent.self)
    private var context: ModelContext
    
    init() {
        context = container.mainContext
    }
    
    func save(events: [EventDTO]) {
        for dto in events {
            let model = CachedEvent(id: dto.id, name: dto.name, imageURL: dto.images.first?.url ?? "")
            context.insert(model)
        }
        
        try? context.save()
    }
    
    func loadEvents() -> [EventDTO] {
        do {
            let results = try context.fetch(FetchDescriptor<CachedEvent>())
            
            return results.map { event in
                EventDTO(id: event.id, name: event.name, url: "", images: [EventImage(ratio: "", url: event.imageURL, width: 10, height: 10, fallback: true)])
            }
        } catch {
            print("\(error)")
            return []
        }
    }
}
