//
//  EventDetailsCoordinator.swift
//  EventTracker
//
//  Created by Admin on 7/2/25.
//
import SwiftUI
import UIKit
import Combine

final class EventDetailsCoordinator {
    private let navigationController: UINavigationController
    private let container: DIContainer
    private let event: EventDTO
    private let didFinish = PassthroughSubject<Void, Never>() // TODO: под вопросом, тут скорее будет тип навигации из модели, а уже потом мы будет отправлять запрос прошлому координатору на удаление
    
    init(navigationController: UINavigationController, container: DIContainer, event: EventDTO) {
        self.navigationController = navigationController
        self.container = container
        self.event = event
    }
    
    func start() {
        let viewModel = container.makeEventDetailsViewModel(event: event)
        let view = EventDetailsView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func finish() {
        didFinish.send()
    }
}
