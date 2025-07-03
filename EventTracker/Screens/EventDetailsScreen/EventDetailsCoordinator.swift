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
    private let image: Image?
    private let id: String
    private let didFinish = PassthroughSubject<Void, Never>() // TODO: под вопросом, тут скорее будет тип навигации из модели, а уже потом мы будет отправлять запрос прошлому координатору на удаление
    
    init(navigationController: UINavigationController, container: DIContainer, image: Image?, id: String) {
        self.navigationController = navigationController
        self.container = container
        self.image = image
        self.id = id
    }
    
    func start() {
        let viewModel = container.makeEventDetailsViewModel(image: image, id: id)
        let view = EventDetailsView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func finish() {
        didFinish.send()
    }
}
