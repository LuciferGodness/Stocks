//
//  EventModel.swift
//  EventTracker
//
//  Created by Admin on 6/28/25.
//
import SwiftData
import UIKit

@Model
final class CachedEvent {
    @Attribute(.unique) var id: UUID
    var eventName: String
    var eventDate: Date
    var eventCategory: String
    var eventLocation: String
    var eventCity: String
    var eventCountry: String
    @Attribute(.externalStorage)
    var eventImage: Data
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
}


