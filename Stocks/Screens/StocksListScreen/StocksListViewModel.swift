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

@MainActor
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
            updateFilteredStocks()
        case .selectSegment(let index):
            state.currentSegment = index
            updateFilteredStocks()
        case .toggleFavorite(let stock):
            toggleFavorite(stock)
        }
    }

    private func loadInitialData() {
        loadFavorites()
        loadStocks()
    }

    private func loadStocks() {
        state.isLoading = true
        
        stocksService.getStocks()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.state.isLoading = false
                
                if case .failure(let error) = completion {
                    self.state.error = error.localizedDescription
                }
            }, receiveValue: { [weak self] stocks in
                guard let self = self else { return }
                self.state.allStocks = stocks
                self.updateFilteredStocks()
            })
            .store(in: &cancellables)
    }

    private func loadFavorites() {
        state.favoriteStocks = stocksService.getFavoriteStocks()
        updateFilteredStocks()
    }

    private func toggleFavorite(_ stock: StocksDTO) {
        Task {
            await stocksService.toggleFavorite(stock: stock)
            self.loadFavorites()
        }
    }

    private func updateFilteredStocks() {
        let source = state.currentSegment == 0 ? state.allStocks : state.favoriteStocks
        
        guard !state.searchQuery.isEmpty else {
            state.filteredStocks = source
            return
        }

        let query = state.searchQuery.lowercased()

        state.filteredStocks = source.filter {
            $0.symbol.lowercased().contains(query) || $0.name.lowercased().contains(query)
        }
    }
}
