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
    func getFavoriteStocks() -> [StocksDTO]
    func toggleFavorite(stock: StocksDTO) async
    func isFavorite(stock: StocksDTO) -> Bool
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
    
    func getFavoriteStocks() -> [StocksDTO] {
        return cacheService.load()
    }
    
    func isFavorite(stock: StocksDTO) -> Bool {
        return cacheService.isFavorite(stock)
    }
    
    func toggleFavorite(stock: StocksDTO) async {
        if isFavorite(stock: stock) {
            await cacheService.remove(stock)
        } else {
            await cacheService.add(stock)
        }
    }
}
