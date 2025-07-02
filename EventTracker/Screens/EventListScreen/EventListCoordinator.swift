//
//  EventListCoordinator.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import SwiftUI
import Combine
import UIKit

final class EventListCoordinator {
    private let navigationController: UINavigationController
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    private var childCoordinators = [AnyObject]()
    
    init(navigationController: UINavigationController, container: DIContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let viewModel = container.makeEventListViewModel()
        let eventListView = EventListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: eventListView)
        
        observeNavigationEvents(viewModel: viewModel)
        
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    private func observeNavigationEvents(viewModel: EventListViewModel) {
        print("Here")
        viewModel.navigation
            .sink { [weak self] navigation in
                switch navigation {
                case .select(let event):
                    print("Selected event coordinator: \(event.name)")
                    self?.openEventDetails(event: event)
                }
            }.store(in: &cancellables)
    }
    
    private func openEventDetails(event: EventDTO) {
        let newCoordinator = EventDetailsCoordinator(navigationController: navigationController,
                                container: container,
                                event: event)
        
        childCoordinators.append(newCoordinator)
        
//        newCoordinator.didFinish
//            .sink {
//                removeChildCoordinator()
//            }.store(in: cancellables)
        
        newCoordinator.start()
    }
    
    private func removeChildCoordinator() {
        childCoordinators.removeLast()
    }
}
