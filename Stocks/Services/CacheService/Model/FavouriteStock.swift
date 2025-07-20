//
//  CachedEvent.swift
//  EventTracker
//
//  Created by Admin on 6/28/25.
//
import Foundation
import SwiftData

@Model
final class FavouriteStock: ManagedObject {
    typealias DTO = StocksDTO
    
    var logo: String
    var changePercent: Double
    var symbol: String
    var name: String
    var price: Double
    var change: Double
    
    init(stock: StocksDTO) {
        self.logo = stock.logo
        self.changePercent = stock.changePercent
        self.symbol = stock.symbol
        self.name = stock.name
        self.price = stock.price
        self.change = stock.change
    }
    
    func toDTO() -> StocksDTO {
        return StocksDTO(stock: self)
    }
}


