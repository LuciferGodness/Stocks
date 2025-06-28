//
//  EventService.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//
import Foundation
import Combine
import Network

protocol EventServiceProtocol {
    func getEvents() -> AnyPublisher<[EventDTO], Error>
}

final class EventService: EventServiceProtocol {
    private let apiService: APIServiceProtocol
    private let cacheService: CacheServiceProtocol
    private let monitor: NWPathMonitor
    
    init(apiService: APIServiceProtocol, cacheService: CacheServiceProtocol) {
        self.apiService = apiService
        self.cacheService = cacheService
        self.monitor = NWPathMonitor()
        self.monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    func getEvents() -> AnyPublisher<[EventDTO], Error> {
        if monitor.currentPath.status == .satisfied {
            return apiService.request(.getAllEvents)
                .map { (response: EventResponseDTO) in
                    response.embedded.events
                }
                .handleEvents(receiveOutput: { [weak self] events in
                    self?.cacheService.save(events: events)
                })
                .eraseToAnyPublisher()
        } else {
           return Just(cacheService.loadEvents())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
