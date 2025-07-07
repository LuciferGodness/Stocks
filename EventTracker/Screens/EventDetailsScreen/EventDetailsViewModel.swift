//
//  EventDetailsViewModel.swift
//  EventTracker
//
//  Created by Admin on 7/2/25.
//
import Combine
import SwiftUICore

enum EventDetailsActions {
    case appear
}

struct EventDetailsViewState {
    var detail: EventDetailsDTO? = nil
    var error: String? = nil
    var isLoading: Bool = false
}

final class EventDetailsViewModel: ObservableObject {
    private let eventService: EventServiceProtocol
    @Published private(set)var state = EventDetailsViewState()
    private var cancellables = Set<AnyCancellable>()
    let id: String
    
    init(eventService: EventServiceProtocol, id: String) {
        self.eventService = eventService
        self.id = id
    }
    
    func send(_ input: EventDetailsActions) {
        switch input {
        case .appear:
            loadEventDetails()
        }
    }
    
    private func loadEventDetails() {
        state.isLoading = true
        eventService.getEventDetails(id: id)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.state.isLoading = false
                case .failure(let failure):
                    self?.state.error = failure.localizedDescription
                }
            }, receiveValue: { [weak self] detail in
                self?.state.detail = detail
            }).store(in: &cancellables)
    }
}
