//
//  EventService.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//
import Foundation
import Combine

protocol EventServiceProtocol {
    func getEvents() -> AnyPublisher<[EventDTO], Error>
}

final class EventService: EventServiceProtocol {
    private let apiService: APIServiceProtocol
    private let cacheService: CacheServiceProtocol
    
    init(apiService: APIServiceProtocol, cacheService: CacheServiceProtocol) {
        self.apiService = apiService
        self.cacheService = cacheService
    }
    
    func getEvents() -> AnyPublisher<[EventDTO], Error> {
        apiService.request(.getAllEvents)
            .map { (response: EventResponseDTO) in
                response.embedded.events
            }
            .eraseToAnyPublisher()
    }
}
