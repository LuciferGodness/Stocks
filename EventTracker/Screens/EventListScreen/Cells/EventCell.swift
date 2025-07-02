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
        VStack(spacing: 16) {
            TabView {
                if let imageDatas = event.imageDatas, !imageDatas.isEmpty {
                    ForEach(imageDatas, id: \.self) { imageData in
                        if let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 250)
                                .clipped()
                                .cornerRadius(12)
                                .padding(.horizontal)
                        } else {
                            ProgressView()
                                .frame(height: 250)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                    }
                } else {
                    AsyncImage(url: URL(string: event.images.first?.url ?? "")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 250)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 250)
                                    .clipped()
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            case .failure:
                                Color.gray
                                    .frame(height: 250)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .frame(height: 260)
            
            Text(event.name)
                .font(.title)
                .bold()
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
            
            HStack(spacing: 6) {
                ForEach(classificationLabels, id: \.self) { label in
                    GenreLabel(text: label)
                }
            }
            .padding(.bottom, 20)
            Spacer()
        }
}

extension EventCell {
    private var classificationLabels: [String] {
        event.classifications.flatMap { classification in
            [
                classification.segment.name,
                classification.genre.name,
                classification.subGenre.name
            ]
        }
        .compactMap { $0 }
    }
}
