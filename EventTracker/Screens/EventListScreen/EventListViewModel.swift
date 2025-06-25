//
//  EventListViewModel.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import Combine

protocol EventListViewModelProtocol: ObservableObject {
    
}

final class EventListViewModel: EventListViewModelProtocol {
    @Published var errorMessage: String?
    
    private let eventService: EventServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(eventService: EventServiceProtocol) {
        self.eventService = eventService
    }
}
