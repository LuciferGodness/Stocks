//
//  EventListViewModel.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import Combine
import SwiftUICore
import CoreLocation

enum EventListViewAction {
    case appear
    case select(id: String)
    case filter
}

struct EventListViewState {
    var events: [EventDTO] = []
    var error: String? = nil
    var isLoading: Bool = false
}

final class EventListViewModel: ObservableObject {
    enum NavigationEvent {
        case select(id: String)
    }
    
    @Published private(set)var state = EventListViewState()
    
    private let eventService: EventServiceProtocol
    private let locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    var navigation = PassthroughSubject<NavigationEvent, Never>()
    
    init(eventService: EventServiceProtocol, locationManager: LocationManager) {
        self.eventService = eventService
        self.locationManager = locationManager
    }
    
    func send(_ action: EventListViewAction) {
        switch action {
        case .appear:
            loadEvents()
        case .select(let id):
            navigation.send(.select(id: id))
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
