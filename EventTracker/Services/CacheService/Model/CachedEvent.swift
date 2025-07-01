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
    
    init(id: String, name: String, images: [CachedEventImage] = []) {
        self.id = id
        self.name = name
        self.images = images
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
