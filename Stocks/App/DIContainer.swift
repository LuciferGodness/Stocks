//
//  DIContainer.swift
//  EventTracker
//
//  Created by Admin on 6/24/25.
//

import SwiftUICore
import SwiftData

final class DIContainer {
    private let apiService: APIServiceProtocol
    private let cacheService: CacheServiceProtocol
    private let stocksService: StocksServiceProtocol
    let imageService: ImageServiceProtocol
    
    init() {
        self.apiService = APIService()
        self.cacheService = CacheService()
        self.imageService = ImageService()
        self.stocksService = StocksService(apiService: apiService, cacheService: cacheService)
    }
    
    func makeEventListViewModel() -> StocksListViewModel {
        StocksListViewModel(stocksService: stocksService)
    }
}
