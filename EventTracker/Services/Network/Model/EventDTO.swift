//
//  EventDTO.swift
//  EventTracker
//
//  Created by Admin on 6/27/25.
//

struct EventResponseDTO: Codable {
    let embedded: EmbeddedEvents

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct EmbeddedEvents: Codable {
    let events: [EventDTO]
}

struct EventDTO: Codable, Identifiable {
    let id: String
    let name: String
    let url: String
    let images: [EventImage]
}

struct EventImage: Codable {
    let ratio: String
    let url: String
    let width: Int
    let height: Int
    let fallback: Bool
}
