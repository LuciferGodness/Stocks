//
//  EventService.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

protocol EventServiceProtocol {
    
}

final class EventService: EventServiceProtocol {
    private let apiService: APIServiceProtocol
    private let cacheService: CacheServiceProtocol
    
    init(apiService: APIServiceProtocol, cacheService: CacheServiceProtocol) {
        self.apiService = apiService
        self.cacheService = cacheService
    }
}
