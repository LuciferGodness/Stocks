//
//  CachedEvent.swift
//  EventTracker
//
//  Created by Admin on 6/28/25.
//
import Foundation
import SwiftData

@Model
final class CachedEvent: ManagedObject {
    typealias DTO = EventDTO
    
    @Attribute(.unique) var id: UUID
    var eventName: String
    var eventDate: String
    var eventCategory: String
    var eventLocation: String
    var eventCity: String
    var eventCountry: String
    var eventImage: String
    var eventDescription: String
    var eventAttendees: Int
    var eventTicketPrice: String
    
    init(event: EventDTO) {
        self.id = event.eventTicketId
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
    }
    
    func toDTO() -> EventDTO {
        return EventDTO(event: self)
    }
}


