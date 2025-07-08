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
    case getEventsNear(lat: Double, lon: Double)
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
            "event/\(id).json/"
        case .getEventsNear(let lat, let lon):
            "/eventsNear.json?\(lat)/\(lon)/"
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
        components.queryItems = [
            URLQueryItem(name: "key", value: "8686d0d0")
        ]
        
        return components.url
    }
}
