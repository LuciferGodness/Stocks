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
        
        for dto in events {
            let model = CachedEvent(id: dto.id, name: dto.name, classifications: dto.classifications)
            var imageDatas = [CachedEventImage]()
            
            await withTaskGroup(of: Data?.self) { group in
                if let url = dto.images.first?.url {
                    group.addTask {
                        await self.downloadImages(url: url)
                    }
                    
                    for await data in group {
                        if let imageData = data {
                            let imageModel = CachedEventImage(imageData: imageData, event: model)
                            imageDatas.append(imageModel)
                        }
                    }
                }
            }
            
            model.images = imageDatas
            
            context.insert(model)
        }
        
        try? context.save()
    }
    
    @MainActor
    func loadEvents() -> [EventDTO] {
        context = container.mainContext
        
        do {
            let results = try context.fetch(FetchDescriptor<CachedEvent>())
            
            return results.map { event in
                EventDTO(id: event.id, name: event.name, images: [], classifications: event.classifications, imageDatas: event.images.map { $0.imageData })
            }
        } catch {
            print("\(error)")
            return []
        }
    }
    
    private func downloadImages(url: String) async -> Data? {
        guard let urlTask = URL(string: url) else {
            return nil
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: urlTask)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return nil
            }
            
            return data
        } catch {
            print("Failed to download image \(error)")
            return nil
        }
    }
}
