//
//  EventDTO.swift
//  EventTracker
//
//  Created by Admin on 6/27/25.
//

import Foundation

struct EventResponseDTO: Codable {
    let embedded: EmbeddedEvents

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct EmbeddedEvents: Codable {
    let attractions: [EventDTO]
}

struct EventDTO: Codable, Identifiable {
    let id: String
    let name: String
    let images: [EventImage]
    let classifications: [EventClassifications]
    
    let imageDatas: [Data]?
}

struct EventImage: Codable {
    let url: String
}

struct EventClassifications: Codable {
    let segment: Segment
    let genre: Segment
    let subGenre: Segment
    
    struct Segment: Codable {
        let id: String
        let name: String
    }
}
