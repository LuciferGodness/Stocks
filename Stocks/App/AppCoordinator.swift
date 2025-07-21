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
    
    @MainActor func start() {
        let stocksListCoordinator = StocksListCoordinator(
            navigationController: navigationController,
            container: container
        )
        
        childCoordinators.append(stocksListCoordinator)
        
        stocksListCoordinator.start()
        
        window.rootViewController = navigationController
        window.overrideUserInterfaceStyle = .light
        window.makeKeyAndVisible()
    }
}
