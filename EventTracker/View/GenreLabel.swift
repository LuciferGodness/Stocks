//
//  GenreLabel.swift
//  EventTracker
//
//  Created by Admin on 7/2/25.
//

import SwiftUI

struct GenreLabel: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .bold()
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.8))
            .clipShape(Capsule())
    }
}
