//
//  EventListViewModel.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import Combine

protocol EventListViewModelProtocol: ObservableObject {
    func loadEvents()
}

final class EventListViewModel: EventListViewModelProtocol {
    @Published var errorMessage: String?
    
    private let eventService: EventServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(eventService: EventServiceProtocol) {
        self.eventService = eventService
    }
    
    func loadEvents() {
        eventService.getEvents()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }, receiveValue: { [weak self] events in
                print(events)
            })
            .store(in: &cancellables)
    }
}
