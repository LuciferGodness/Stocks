//
//  EventDetailsDTO.swift
//  EventTracker
//
//  Created by Admin on 7/3/25.
//

import Foundation

struct EventDetailsDTO: Codable, Cacheable {
    typealias ManagedModel = CachedEventDetails
    
    let id: UUID
    let eventName: String
    let eventDescription: String
    let eventDate: String
    let eventLocation: String
    let organizerName: String
    let organizerEmail: String
    let ticketPrice: Int
    let eventCategory: String
    let eventCapacity: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "event_ticket_id"
        case eventName = "event_name"
        case eventDescription = "event_description"
        case eventDate = "event_date"
        case eventLocation = "event_location"
        case organizerName = "organizer_name"
        case organizerEmail = "organizer_email"
        case ticketPrice = "ticket_price"
        case eventCategory = "event_category"
        case eventCapacity = "event_capacity"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        eventName = try container.decode(String.self, forKey: .eventName)
        eventDescription = try container.decode(String.self, forKey: .eventDescription)
        eventDate = try container.decode(String.self, forKey: .eventDate)
        eventLocation = try container.decode(String.self, forKey: .eventLocation)
        organizerName = try container.decode(String.self, forKey: .organizerName)
        organizerEmail = try container.decode(String.self, forKey: .organizerEmail)
        ticketPrice = try container.decode(Int.self, forKey: .ticketPrice)
        eventCategory = try container.decode(String.self, forKey: .eventCategory)
        eventCapacity = try container.decode(Int.self, forKey: .eventCapacity)
        id = try container.decode(UUID.self, forKey: .id)
    }
    
    func toManagedObject() -> CachedEventDetails {
        return CachedEventDetails(details: self)
    }
}

extension EventDetailsDTO {
    init(eventDetails: CachedEventDetails) {
        self.id = eventDetails.id
        self.eventName = eventDetails.eventName
        self.eventDescription = eventDetails.eventDescription
        self.eventDate = eventDetails.eventDate
        self.eventLocation = eventDetails.eventLocation
        self.organizerName = eventDetails.organizerName
        self.organizerEmail = eventDetails.organizerEmail
        self.ticketPrice = eventDetails.ticketPrice
        self.eventCategory = eventDetails.eventCategory
        self.eventCapacity = eventDetails.eventCapacity
    }
}
