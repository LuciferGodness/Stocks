//
//  EventDetailsView.swift
//  EventTracker
//
//  Created by Admin on 7/2/25.
//

import SwiftUI

struct EventDetailsView: View {
    @ObservedObject var viewModel: EventDetailsViewModel
    
    var body: some View {
        VStack {
            if viewModel.state.isLoading {
                ProgressView()
            } else if let error = viewModel.state.error {
                Text(error)
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        Text(viewModel.state.detail?.eventName ?? "")
                        Text(viewModel.state.detail?.eventDescription ?? "")
                        Text(viewModel.state.detail?.eventLocation ?? "")
                    }
                }
            }
        }
        .onAppear {
            viewModel.send(.appear)
        }
    }
}
