//
//  EventDTO.swift
//  EventTracker
//
//  Created by Admin on 6/27/25.
//

import Foundation
import UIKit

struct StocksDTO: Codable, Cacheable {
    let logo: String
    let changePercent: Double
    let symbol: String
    let name: String
    let price: Double
    let change: Double
    typealias ManagedModel = FavouriteStock
    
    func toManagedObject() -> FavouriteStock {
        return FavouriteStock(stock: self)
    }
}

extension StocksDTO {
    init(stock: FavouriteStock) {
        self.logo = stock.logo
        self.changePercent = stock.changePercent
        self.symbol = stock.symbol
        self.name = stock.name
        self.price = stock.price
        self.change = stock.change
    }
}
