//
//  DIContainer.swift
//  EventTracker
//
//  Created by Admin on 6/24/25.
//

struct DIContainer {
    let apiService: APIServiceProtocol
    let cacheService: CacheServiceProtocol
    let eventService: EventServiceProtocol
    
    init() {
        self.apiService = APIService()
        self.cacheService = CacheService()
        self.eventService = EventService(apiService: apiService, cacheService: cacheService)
    }
    
    func makeEventListViewModel() -> EventListViewModel {
        EventListViewModel(eventService: eventService)
    }
}
