//
//  StocksListViewModel.swift
//  Stocks
//
//  Created by Admin on 6/25/25.
//

import Combine
import SwiftUICore
import CoreLocation

enum StocksListViewAction {
    case appear
    case seach(sequence: String)
}

struct StocksListViewState {
    var stocks: [StocksDTO] = []
    var error: String? = nil
    var isLoading: Bool = false
}

final class StocksListViewModel: ObservableObject {
    @Published private(set)var state = StocksListViewState()
    
    private let stocksService: StocksServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(stocksService: StocksServiceProtocol) {
        self.stocksService = stocksService
    }
    
    func send(_ action: StocksListViewAction) {
        switch action {
        case .appear:
            loadStocks()
        case .seach(let sequence):
            searchStocks()
        }
    }
    
    private func loadStocks() {
        state.isLoading = true
        stocksService.getStocks()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.state.isLoading = false
                case .failure(let failure):
                    self?.state.error = failure.localizedDescription
                }
            }, receiveValue: { [weak self] stocks in
                self?.state.stocks = stocks
                print(stocks)
            })
            .store(in: &cancellables)
    }
    
    private func searchStocks() {
        
    }
}
