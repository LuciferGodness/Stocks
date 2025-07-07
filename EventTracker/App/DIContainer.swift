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
    private let locationManager: LocationManager
    
    init() {
        self.apiService = APIService()
        self.cacheService = CacheService()
        self.eventService = EventService(apiService: apiService, cacheService: cacheService)
        self.locationManager = LocationManager()
    }
    
    func makeEventListViewModel() -> EventListViewModel {
        EventListViewModel(eventService: eventService, locationManager: locationManager)
    }
    
    func makeEventDetailsViewModel(id: String) -> EventDetailsViewModel {
        EventDetailsViewModel(eventService: eventService, id: id)
    }
}
