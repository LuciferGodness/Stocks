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
                VStack(spacing: 16) {
                    if let image = viewModel.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                    }
                    Text(viewModel.state.detail?.name ?? "")
                    Text(viewModel.state.detail?.description ?? "")
                    Text(viewModel.state.detail?.additionalInfo ?? "")
                }
            }
        }
        .onAppear {
            viewModel.send(.appear)
        }
    }
}
