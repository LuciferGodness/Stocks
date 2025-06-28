//
//  EventModel.swift
//  EventTracker
//
//  Created by Admin on 6/28/25.
//
import SwiftData

@Model
final class CachedEvent {
    var id: String
    var name: String
    var imageURL: String
    
    init(id: String, name: String, imageURL: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }
}
