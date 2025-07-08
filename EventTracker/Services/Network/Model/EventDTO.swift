//
//  EventDTO.swift
//  EventTracker
//
//  Created by Admin on 6/27/25.
//

import Foundation
import UIKit

struct EventDTO: Codable, Cacheable {
    let eventName: String
    let eventDate: String
    let eventCategory: String
    let eventLocation: String
    let eventCity: String
    let eventCountry: String
    let eventImage: String
    let eventDescription: String
    let eventAttendees: Int
    let eventTicketPrice: String
    let eventTicketId: UUID
    typealias ManagedModel = CachedEvent

    enum CodingKeys: String, CodingKey {
        case eventName = "event_name"
        case eventDate = "event_date"
        case eventCategory = "event_category"
        case eventLocation = "event_location"
        case eventCity = "event_city"
        case eventCountry = "event_country"
        case eventImage = "event_image"
        case eventDescription = "event_description"
        case eventAttendees = "event_attendees"
        case eventTicketPrice = "event_ticket_price"
        case eventTicketId = "event_ticket_id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        eventName = try container.decode(String.self, forKey: .eventName)
        eventDate = try container.decode(String.self, forKey: .eventDate)
        eventCategory = try container.decode(String.self, forKey: .eventCategory)
        eventLocation = try container.decode(String.self, forKey: .eventLocation)
        eventCity = try container.decode(String.self, forKey: .eventCity)
        eventCountry = try container.decode(String.self, forKey: .eventCountry)
        eventImage = try container.decode(String.self, forKey: .eventImage)
        eventDescription = try container.decode(String.self, forKey: .eventDescription)
        eventAttendees = try container.decode(Int.self, forKey: .eventAttendees)
        eventTicketPrice = try container.decode(String.self, forKey: .eventTicketPrice)
        eventTicketId = try container.decode(UUID.self, forKey: .eventTicketId)
    }
    
    func toManagedObject() -> CachedEvent {
        return CachedEvent(event: self)
    }
}

extension EventDTO {
    var image: UIImage? {
        guard let base64String = eventImage.components(separatedBy: ",").last,
              let imageData = Data(base64Encoded: base64String) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    init(event: CachedEvent) {
        self.eventName = event.eventName
        self.eventDate = event.eventDate
        self.eventCategory = event.eventCategory
        self.eventLocation = event.eventLocation
        self.eventCity = event.eventCity
        self.eventCountry = event.eventCountry
        self.eventImage = event.eventImage
        self.eventDescription = event.eventDescription
        self.eventAttendees = event.eventAttendees
        self.eventTicketPrice = event.eventTicketPrice
        self.eventTicketId = event.id
    }
}
