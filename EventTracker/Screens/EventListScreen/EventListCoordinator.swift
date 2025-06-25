//
//  EventListCoordinator.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import SwiftUI

import UIKit

final class EventListCoordinator {
    private let navigationController: UINavigationController
    private let container: DIContainer

    init(navigationController: UINavigationController, container: DIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let viewModel = container.makeEventListViewModel()
        let eventListView = EventListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: eventListView)

        navigationController.pushViewController(hostingController, animated: true)
    }
}
