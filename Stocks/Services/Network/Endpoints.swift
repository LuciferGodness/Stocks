//
//  Endpoints.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//
import Foundation

enum Endpoints {
    case getAllStocks
}

extension Endpoints {
    var basePath: String {
        "https://mustdev.ru/api/"
    }
    
    var path: String {
        switch self {
        case .getAllStocks:
            "stocks.json"
        }
    }
    
    var method: String {
        return "GET"
    }
    
    var headers: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    var url: URL? {
        guard var components = URLComponents(string: basePath + path) else {
            return nil
        }
        
        return components.url
    }
}
