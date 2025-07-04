//
//  Endpoints.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//
import Foundation

enum Endpoints {
    case getAllEvents(lat: Double, lon: Double)
    case getEventByID(id: String)
}

extension Endpoints {
    var basePath: String {
        "https://api.predicthq.com/v1/"
    }
    
    var path: String {
        switch self {
        case .getAllEvents(_, _):
            "events/"
        case .getEventByID(let id):
            "events/\(id)/"
        }
    }
    
    var method: String {
        return "GET"
    }
    
    var headers: [String: String] {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer nWn6uyilIoRiBMUict4wCRYTYLR_9wOPeXRozcIf"
        ]
    }
    
    var url: URL? {
        guard var components = URLComponents(string: basePath + path) else {
            return nil
        }
        
        switch self {
        case .getAllEvents(let lat, let lon):
            components.queryItems = [
                URLQueryItem(name: "location.latitude", value: "\(lat)"),
                URLQueryItem(name: "location.longitude", value: "\(lon)")
            ]
        case .getEventByID:
            break
        }
        
        return components.url
    }
}
