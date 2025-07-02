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
        Text(viewModel.event.name)
    }
}
