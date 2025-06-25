//
//  EventListView.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import SwiftUI

struct EventListView<ViewModel: EventListViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}
