//
//  EventListView.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import SwiftUI

struct EventListView: View {
    @ObservedObject var viewModel: EventListViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack() {
                if viewModel.state.isLoading {
                    ProgressView()
                } else if let error = viewModel.state.error {
                    Text("Error: \(error)")
                } else {
                    ForEach(viewModel.state.events, id: \.id) { event in
                        EventCell(event: event) { image in
                            viewModel.send(.select(image: image, id: event.id))
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.send(.appear)
        }
        .navigationTitle("Events")
    }
}
