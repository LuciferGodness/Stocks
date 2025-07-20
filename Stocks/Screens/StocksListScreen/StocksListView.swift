//
//  StocksListView.swift
//  Stocks
//
//  Created by Admin on 6/25/25.
//

import UIKit
import SnapKit
import Combine

class StocksListView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    let searchBar = CustomSearchBar()
    private let stocksLabel = UILabel()
    private let favouriteLabel = UILabel()
    private var activeLabel: UILabel!
    let tableView = UITableView()
    private let searchSuggestionsView = SearchSuggestionsView()
    
    private var viewModel: StocksListViewModel!
    private var cancellables = Set<AnyCancellable>()

    
    init(viewModel: StocksListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stocks"
        
        setupViews()
        setupSearchSuggestionsView()
        layoutViews()
        bindViewModel()
        
        viewModel.send(.appear)
    }
    
    private func setupViews() {
        searchBar.delegate = self
        view.addSubview(searchBar)
        view.backgroundColor = .white
        
        stocksLabel.text = "Stocks"
        favouriteLabel.text = "Favourite"
        
        [stocksLabel, favouriteLabel].forEach { label in
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:)))
            label.addGestureRecognizer(tapGesture)
            view.addSubview(label)
        }
        
        activeLabel = stocksLabel
        updateTabAppearance()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StockCell.self, forCellReuseIdentifier: "StockCell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    private func layoutViews() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.left.right.equalToSuperview()
        }

        stocksLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(16)
        }

        favouriteLabel.snp.makeConstraints { make in
            make.bottom.equalTo(stocksLabel)
            make.left.equalTo(stocksLabel.snp.right).offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stocksLabel.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func tabTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedLabel = sender.view as? UILabel else { return }
        activeLabel = tappedLabel
        updateTabAppearance()
        
        let selectedIndex = (tappedLabel == stocksLabel) ? 0 : 1
        viewModel.send(.selectSegment(index: selectedIndex))
    }

    private func updateTabAppearance() {
        UIView.animate(withDuration: 0.3) {
            self.stocksLabel.font = (self.activeLabel == self.stocksLabel) ? .boldSystemFont(ofSize: 32) : .systemFont(ofSize: 22, weight: .medium)
            self.stocksLabel.textColor = (self.activeLabel == self.stocksLabel) ? .label : .systemGray

            self.favouriteLabel.font = (self.activeLabel == self.favouriteLabel) ? .boldSystemFont(ofSize: 32) : .systemFont(ofSize: 22, weight: .medium)
            self.favouriteLabel.textColor = (self.activeLabel == self.favouriteLabel) ? .label : .systemGray
            self.view.layoutIfNeeded()
        }
    }

    private func setupSearchSuggestionsView() {
        view.addSubview(searchSuggestionsView)
        searchSuggestionsView.isHidden = true
        searchSuggestionsView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        let popular = ["Apple", "Amazon", "Google", "Tesla", "Facebook", "Nvidia"]
        let recent = ["Microsoft", "Intel", "AMD", "Yandex", "Nokia"]
        searchSuggestionsView.configure(popular: popular, recent: recent)

        searchSuggestionsView.onSuggestionTapped = { [weak self] suggestion in
            guard let self = self else { return }
            self.searchBar.text = suggestion
            self.searchBar(self.searchBar, textDidChange: suggestion)
            self.searchBar.resignFirstResponder()
        }
    }

    // MARK: - UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: false)

        if let customSearchBar = searchBar as? CustomSearchBar {
            customSearchBar.showBackButton()
        }

        stocksLabel.isHidden = true
        favouriteLabel.isHidden = true
        tableView.isHidden = true
        searchSuggestionsView.isHidden = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.send(.search(query: searchText))
        
        if searchText.isEmpty {
            tableView.isHidden = true
            searchSuggestionsView.isHidden = false
        } else {
            tableView.isHidden = false
            searchSuggestionsView.isHidden = true
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let customSearchBar = searchBar as? CustomSearchBar {
            customSearchBar.hideBackButton()
        }

        searchBar.text = ""
        searchBar.resignFirstResponder()

        viewModel.send(.search(query: ""))
        stocksLabel.isHidden = false
        favouriteLabel.isHidden = false
        tableView.isHidden = false
        searchSuggestionsView.isHidden = true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.filteredStocks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as? StockCell else {
            return UITableViewCell()
        }
        
        let stock = viewModel.state.filteredStocks[indexPath.row]
        let isFavorite = viewModel.state.favoriteStocks.contains(where: { $0.symbol == stock.symbol })
        let backgroundColor: UIColor = indexPath.row % 2 == 0 ? .systemBackground : .systemGray6
        
        cell.configure(with: stock, isFavorite: isFavorite, imageService: viewModel.imageService, backgroundColor: backgroundColor)

        cell.onFavoriteButtonTapped = { [weak self] in
            self?.viewModel.send(.toggleFavorite(stock: stock))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let stock = self.viewModel.state.filteredStocks[indexPath.row]
        let isFavorite = self.viewModel.state.favoriteStocks.contains(where: { $0.symbol == stock.symbol })

        let title = isFavorite ? "Unfavorite" : "Favorite"
        let action = UIContextualAction(style: .normal, title: title) { [weak self] (_, _, completion) in
            self?.viewModel.send(.toggleFavorite(stock: stock))
            completion(true)
        }

        action.backgroundColor = isFavorite ? .red : .systemBlue
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
