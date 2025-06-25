//
//  AppCoordinator.swift
//  EventTracker
//
//  Created by Admin on 6/24/25.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let container: DIContainer
    
    init(window: UIWindow, container: DIContainer) {
        self.window = window
        self.navigationController = UINavigationController()
        self.container = container
    }
    
    func start() {
        let viewModel = container.makeEventListViewModel()
        let eventListVC = EventListViewController(viewModel: viewModel)
        
        navigationController.viewControllers = [eventListVC]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
