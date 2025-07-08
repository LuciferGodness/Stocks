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
    func getEventDetails(id: String) -> AnyPublisher<EventDetailsDTO, Error>
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
                .handleEvents(receiveOutput: { [weak self] events in
                    Task {
                        await self?.cacheService.save(events)
                    }
                })
                .eraseToAnyPublisher()
        } else {
            return Just(cacheService.load())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func getEventDetails(id: String) -> AnyPublisher<EventDetailsDTO, Error> {
        if monitor.currentPath.status == .satisfied {
            return apiService.request(.getEventByID(id: id))
                .handleEvents(receiveOutput: { [weak self] eventDetail in
                    Task {
                        await self?.cacheService.save([eventDetail])
                    }
                })
                .eraseToAnyPublisher()
        } else {
            return Just(cacheService.load().first!)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
