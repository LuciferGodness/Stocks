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
    private var childCoordinators = [Any]()
    
    init(window: UIWindow, container: DIContainer) {
        self.window = window
        self.navigationController = UINavigationController()
        self.container = container
    }
    
    func start() {
        let eventListCoordinator = EventListCoordinator(
            navigationController: navigationController,
            container: container
        )
        
        childCoordinators.append(eventListCoordinator)
        
        eventListCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
