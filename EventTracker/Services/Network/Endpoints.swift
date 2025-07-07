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
            "event/\(id).json/"
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
        
        switch self {
        case .getAllEvents:
            break
        case .getEventByID:
            break
        }
        
        return components.url
    }
}
