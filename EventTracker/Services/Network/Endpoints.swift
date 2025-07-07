//
//  Endpoints.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//
import Foundation

enum Endpoints {
    case getAllEvents
    case getEventByID(id: String)
}

extension Endpoints {
    var basePath: String {
        "https://my.api.mockaroo.com/"
    }
    
    var path: String {
        switch self {
        case .getAllEvents:
            "events.json"
        case .getEventByID(let id):
            "events/\(id)/"
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
        
        switch self {
        case .getAllEvents:
            components.queryItems = [
                URLQueryItem(name: "key", value: "8686d0d0")
            ]
        case .getEventByID:
            break
        }
        
        return components.url
    }
}
