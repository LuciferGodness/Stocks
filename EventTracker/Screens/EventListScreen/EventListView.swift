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
        VStack {
            if viewModel.state.isLoading {
                ProgressView()
            } else if let error = viewModel.state.error {
                Text("Error: \(error)")
            } else {
                List(viewModel.state.events, id: \.id) { event in
                    EventCell(event: event)
                        .onTapGesture {
                            viewModel.send(action: .select(event: event))
                        }
                }
            }
        }
        .onAppear {
            viewModel.send(action: .appear)
        }
    }
}
