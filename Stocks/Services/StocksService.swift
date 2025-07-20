//
//  StocksService.swift
//  Stocks
//
//  Created by Admin on 6/25/25.
//
import Foundation
import Combine

protocol StocksServiceProtocol {
    func getStocks() -> AnyPublisher<[StocksDTO], Error>
}

final class StocksService: StocksServiceProtocol {
    private let apiService: APIServiceProtocol
    private let cacheService: CacheServiceProtocol
    
    init(apiService: APIServiceProtocol, cacheService: CacheServiceProtocol) {
        self.apiService = apiService
        self.cacheService = cacheService
    }
    
    func getStocks() -> AnyPublisher<[StocksDTO], Error> {
        return apiService.request(.getAllStocks)
            .eraseToAnyPublisher()
    }
}
