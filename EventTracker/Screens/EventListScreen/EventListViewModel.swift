//
//  EventListViewModel.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import Combine

enum EventListViewAction {
    case appear
    case select(event: EventDTO)
    case filter
}

struct EventListViewState {
    var events: [EventDTO] = []
    var error: String? = nil
    var isLoading: Bool = false
}


final class EventListViewModel: ObservableObject {
    @Published private(set)var state = EventListViewState()
    
    private let eventService: EventServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(eventService: EventServiceProtocol) {
        self.eventService = eventService
    }
    
    func send(action: EventListViewAction) {
        switch action {
        case .appear:
            loadEvents()
        case .select(let event):
            print("selected: \(event.name)")
        case .filter:
            print("filter")
        }
    }
    
    private func loadEvents() {
        state.isLoading = true
        eventService.getEvents()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.state.isLoading = false
                case .failure(let failure):
                    self?.state.error = failure.localizedDescription
                }
            }, receiveValue: { [weak self] events in
                self?.state.events = events
            })
            .store(in: &cancellables)
    }
}
