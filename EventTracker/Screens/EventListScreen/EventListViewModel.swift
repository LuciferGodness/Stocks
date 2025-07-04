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
    case select(image: Image?, id: String)
    case filter
}

struct EventListViewState {
    var events: [EventDTO] = []
    var error: String? = nil
    var isLoading: Bool = false
}

final class EventListViewModel: ObservableObject {
    enum NavigationEvent {
        case select(image: Image?, id: String)
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
        case .select(let image, let id):
            navigation.send(.select(image: image, id: id))
        case .filter:
            print("filter")
        }
    }
    
    private func loadEvents() {
        state.isLoading = true
        var location: CLLocationCoordinate2D
        if let locationLive = locationManager.location {
            location = locationLive
        } else {
            location = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        }
        eventService.getEvents(lat: location.latitude, lon: location.latitude)
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
