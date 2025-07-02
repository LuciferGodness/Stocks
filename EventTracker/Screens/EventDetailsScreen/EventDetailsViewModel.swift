//
//  EventDetailsViewModel.swift
//  EventTracker
//
//  Created by Admin on 7/2/25.
//
import Combine

final class EventDetailsViewModel: ObservableObject {
    private let eventService: EventServiceProtocol
    let event: EventDTO
    
    init(eventService: EventServiceProtocol, event: EventDTO) {
        self.eventService = eventService
        self.event = event
    }
}
