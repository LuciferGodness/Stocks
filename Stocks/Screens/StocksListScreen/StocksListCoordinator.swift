//
//  EventListCoordinator.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import SwiftUI
import Combine
import UIKit

final class StocksListCoordinator {
    private let navigationController: UINavigationController
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    private var childCoordinators = [AnyObject]()
    
    init(navigationController: UINavigationController, container: DIContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    @MainActor func start() {
        let viewModel = container.makeEventListViewModel()
        let stocksListView = StocksListView(viewModel: viewModel)
        
        navigationController.pushViewController(stocksListView, animated: true)
    }
}
