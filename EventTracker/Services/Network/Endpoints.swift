//
//  Endpoints.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//
import Foundation

enum Endpoints {
    case getAllEvents
}

extension Endpoints {
    var basePath: String {
        "https://app.ticketmaster.com/discovery/v2/"
    }
    
    var path: String {
        switch self {
        case .getAllEvents:
            "events.json"
        }
    }
    
    var method: String {
        return "GET"
    }
    
    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    var url: URL? {
        guard var components = URLComponents(string: basePath + path) else {
            return nil
        }
        
        var queryItems = [URLQueryItem(name: "apikey", value: "GoffoHmK82bF2aDs1hXF39aXa2ItYVnE")]
        
        switch self {
        case .getAllEvents:
            queryItems.append(URLQueryItem(name: "size", value: "1"))
        }
        
        components.queryItems = queryItems
        return components.url
    }
}
