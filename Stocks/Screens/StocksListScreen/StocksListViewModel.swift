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
    case search(query: String)
    case selectSegment(index: Int)
    case toggleFavorite(stock: StocksDTO)
}

struct StocksListViewState {
    var allStocks: [StocksDTO] = []
    var favoriteStocks: [StocksDTO] = []
    var filteredStocks: [StocksDTO] = []
    var currentSegment: Int = 0
    var searchQuery: String = ""
    var error: String? = nil
    var isLoading: Bool = false
}

final class StocksListViewModel: ObservableObject {
    @Published private(set) var state = StocksListViewState()
    
    let imageService: ImageServiceProtocol
    private let stocksService: StocksServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(stocksService: StocksServiceProtocol, imageService: ImageServiceProtocol) {
        self.stocksService = stocksService
        self.imageService = imageService
    }
    
    func send(_ action: StocksListViewAction) {
        switch action {
        case .appear:
            loadInitialData()
        case .search(let query):
            state.searchQuery = query
            filterStocks()
        case .selectSegment(let index):
            state.currentSegment = index
            filterStocks()
        case .toggleFavorite(let stock):
            toggleFavorite(stock: stock)
        }
    }
    
    private func loadInitialData() {
        loadFavorites()
        loadStocks()
    }
    
    private func loadStocks() {
        state.isLoading = true
        stocksService.getStocks()
            .sink(receiveCompletion: { [weak self] completion in
                self?.state.isLoading = false
                switch completion {
                case .failure(let failure):
                    self?.state.error = failure.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] stocks in
                self?.state.allStocks = stocks
                self?.filterStocks()
            })
            .store(in: &cancellables)
    }
    
    private func loadFavorites() {
        state.favoriteStocks = stocksService.getFavoriteStocks()
        filterStocks()
    }
    
    private func toggleFavorite(stock: StocksDTO) {
        Task {
            await stocksService.toggleFavorite(stock: stock)
            DispatchQueue.main.async {
                self.loadFavorites()
            }
        }
    }
    
    private func filterStocks() {
        let stocksToFilter = state.currentSegment == 0 ? state.allStocks : state.favoriteStocks
        
        if state.searchQuery.isEmpty {
            state.filteredStocks = stocksToFilter
        } else {
            state.filteredStocks = stocksToFilter.filter { 
                $0.symbol.localizedCaseInsensitiveContains(state.searchQuery) || 
                $0.name.localizedCaseInsensitiveContains(state.searchQuery) 
            }
        }
    }
}
