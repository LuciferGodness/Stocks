//
//  CachedEventDetails.swift
//  EventTracker
//
//  Created by Admin on 7/7/25.
//
import SwiftData

@Model
final class CachedEventDetails {
    var eventName: String
    var eventDescription: String
    var eventDate: String
    var eventLocation: String
    var organizerName: String
    var organizerEmail: String
    var ticketPrice: Int
    var eventCategory: String
    var eventCapacity: Int
    
    init(eventName: String, eventDescription: String, eventDate: String, eventLocation: String, organizerName: String, organizerEmail: String, ticketPrice: Int, eventCategory: String, eventCapacity: Int) {
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.eventDate = eventDate
        self.eventLocation = eventLocation
        self.organizerName = organizerName
        self.organizerEmail = organizerEmail
        self.ticketPrice = ticketPrice
        self.eventCategory = eventCategory
        self.eventCapacity = eventCapacity
    }
}
