//
//  DIContainer.swift
//  EventTracker
//
//  Created by Admin on 6/24/25.
//

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
    
    func makeEventDetailsViewModel(event: EventDTO) -> EventDetailsViewModel {
        EventDetailsViewModel(eventService: eventService, event: event)
    }
}
