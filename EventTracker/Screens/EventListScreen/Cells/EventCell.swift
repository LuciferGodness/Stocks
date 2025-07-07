//
//  Eventcell.swift
//  EventTracker
//
//  Created by Admin on 7/2/25.
//

import SwiftUI

struct EventCell: View {
    let event: EventDTO
    
    var body: some View {
        headerImage
        
        Text(event.eventName)
            .font(.title)
            .bold()
            .multilineTextAlignment(.leading)
        
//        HStack(spacing: 6) {
//            ForEach(classificationLabels, id: \.self) { label in
//                GenreLabel(text: label)
//            }
//        }
        
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(height: 20)
            .padding(.top, 6)
        
    }
    
    var headerImage: some View {
        VStack() {
            TabView {
                Image(uiImage: event.image ?? UIImage())
            }
        }
        .tabViewStyle(.page)
        .frame(height: 250)
        .clipped()
    }
}

extension EventCell {
//    private var classificationLabels: [String] {
//        event.classifications.flatMap { classification in
//            [
//                classification.segment.name,
//                classification.genre.name,
//                classification.subGenre.name
//            ]
//        }
//        .compactMap { $0 }
//    }
}
