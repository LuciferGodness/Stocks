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
    var id: String
    var name: String
    @Attribute(.externalStorage)
    var images: [CachedEventImage]
    var classifications: [EventClassifications]
    
    init(id: String, name: String, images: [CachedEventImage] = [], classifications: [EventClassifications] = []) {
        self.id = id
        self.name = name
        self.images = images
        self.classifications = classifications
    }
}

@Model
final class CachedEventImage {
    var imageData: Data
    var event: CachedEvent?

    init(imageData: Data, event: CachedEvent? = nil) {
        self.imageData = imageData
        self.event = event
    }
}
