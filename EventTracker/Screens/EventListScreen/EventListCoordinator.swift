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
        viewModel.navigation
            .sink { [weak self] navigation in
                switch navigation {
                case .select(let image, let id):
                    self?.openEventDetails(image: image, id: id)
                }
            }.store(in: &cancellables)
    }
    
    private func openEventDetails(image: Image?, id: String) {
        let newCoordinator = EventDetailsCoordinator(navigationController: navigationController,
                                                     container: container,
                                                     image: image,
                                                     id: id)
        
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
