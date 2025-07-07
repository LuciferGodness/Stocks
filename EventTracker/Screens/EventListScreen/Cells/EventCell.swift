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
        VStack(alignment: .leading) {
            HStack() {
                headerImage
                
                VStack(alignment: .leading) {
                    Text(event.eventName)
                        .font(.system(size: 22))
                        .bold()
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(event.eventCity)
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))
                            .multilineTextAlignment(.leading)
                        Text(event.eventDate)
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))
                            .multilineTextAlignment(.leading)
                        Text(event.eventCategory)
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))
                            .multilineTextAlignment(.leading)
                    }
                    
                    Text(event.eventAttendees.description)
                        .font(.system(size: 22))
                        .bold()
                        .multilineTextAlignment(.leading)
                }
            }
            
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 20)
                .padding(.top, 6)
        }
        
    }
    
    var headerImage: some View {
        VStack() {
            TabView {
                if let image = event.image {
                    Image(uiImage: image)
                } else {
                    let base64String = event.eventImage.components(separatedBy: ",").last
                    let imageData = Data(base64Encoded: base64String ?? "")
                    Image(uiImage: UIImage(data: imageData ?? Data()) ?? UIImage())
                }
            }
        }
        .tabViewStyle(.page)
        .frame(width: 20, height: 20)
        .clipped()
    }
}
