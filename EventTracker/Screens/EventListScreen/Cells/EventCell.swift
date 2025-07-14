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
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                headerImage
                eventInfo
            }
            
            Divider()
                .background(Color.gray.opacity(0.4))
        }
    }
    
    private var headerImage: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 75, height: 75)
                .shadow(radius: 2)
            
            if let image = event.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
            } else if let data = Data(base64Encoded: event.eventImage.components(separatedBy: ",").last ?? ""),
                      let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 40, height: 40)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }
        }
        .padding(.leading, 8)
    }
    
    private var eventInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(event.eventCategory)
                .font(.system(size: 16))
                .foregroundColor(.gray)

            HStack {
                Text(event.eventName)
                    .font(.system(size: 20))
                    .bold()

                Spacer()

                Text(event.eventDate)
                    .font(.system(size: 16))
            }

            HStack {
                Text(event.eventCity)
                    .font(.system(size: 16))

                Spacer()

                Text("\(event.eventAttendees)$")
                    .font(.system(size: 16))
                    .bold()
            }
        }
    }
}
