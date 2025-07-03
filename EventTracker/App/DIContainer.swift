//
//  DIContainer.swift
//  EventTracker
//
//  Created by Admin on 6/24/25.
//

import SwiftUICore

final class DIContainer {
    private let apiService: APIServiceProtocol
    private let cacheService: CacheServiceProtocol
    private let eventService: EventServiceProtocol
    
    init() {
        self.apiService = APIService()
        self.cacheService = CacheService()
        self.eventService = EventService(apiService: apiService, cacheService: cacheService)
    }
    
    func makeEventListViewModel() -> EventListViewModel {
        EventListViewModel(eventService: eventService)
    }
    
    func makeEventDetailsViewModel(image: Image?, id: String) -> EventDetailsViewModel {
        EventDetailsViewModel(eventService: eventService, image: image, id: id)
    }
}
