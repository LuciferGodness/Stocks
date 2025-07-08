//
//  CachedEventDetails.swift
//  EventTracker
//
//  Created by Admin on 7/7/25.
//
import Foundation
import SwiftData

@Model
final class CachedEventDetails: ManagedObject {
    typealias DTO = EventDetailsDTO
    
    @Attribute(.unique) let id: UUID
    var eventName: String
    var eventDescription: String
    var eventDate: String
    var eventLocation: String
    var organizerName: String
    var organizerEmail: String
    var ticketPrice: Int
    var eventCategory: String
    var eventCapacity: Int
    
    init(details: EventDetailsDTO) {
        self.id = details.id
        self.eventName = details.eventName
        self.eventDescription = details.eventDescription
        self.eventDate = details.eventDate
        self.eventLocation = details.eventLocation
        self.organizerName = details.organizerName
        self.organizerEmail = details.organizerEmail
        self.ticketPrice = details.ticketPrice
        self.eventCategory = details.eventCategory
        self.eventCapacity = details.eventCapacity
    }
    
    func toDTO() -> EventDetailsDTO {
        return EventDetailsDTO(eventDetails: self)
    }
}
