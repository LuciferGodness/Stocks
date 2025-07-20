//
//  EventListView.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import UIKit
import SnapKit
import Combine

class StocksListView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let searchBar = UISearchBar()
    let segmentedControl = UISegmentedControl(items: ["Stocks", "Favourite"])
    let tableView = UITableView()
    
    private var viewModel: StocksListViewModel!
    private var imageService: ImageServiceProtocol!
    private var cancellables = Set<AnyCancellable>()
    private var searchBarTopConstraint: Constraint?
    
    init(viewModel: StocksListViewModel, imageService: ImageServiceProtocol) {
        self.viewModel = viewModel
        self.imageService = imageService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stocks"
        view.backgroundColor = .systemBackground
        
        setupViews()
        layoutViews()
        bindViewModel()
        
        viewModel.send(.appear)
    }
    
    private func setupViews() {
        searchBar.placeholder = "Find company or ticker"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StockCell.self, forCellReuseIdentifier: "StockCell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    private func layoutViews() {
        searchBar.snp.makeConstraints { make in
            self.searchBarTopConstraint = make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8).constraint
            make.left.right.equalToSuperview().inset(16)
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
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
    
    @objc private func segmentChanged() {
        viewModel.send(.selectSegment(index: segmentedControl.selectedSegmentIndex))
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.send(.search(query: searchText))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.filteredStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as? StockCell else {
            return UITableViewCell()
        }
        
        let stock = viewModel.state.filteredStocks[indexPath.row]
        cell.configure(with: stock, imageService: imageService)
        
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? .systemGray6 : .systemBackground
        
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
    
    // MARK: - ScrollView Delegate for hiding search bar
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let searchBarHeight = searchBar.frame.height
        
        if offsetY > searchBarHeight {
            hideSearchBar()
        } else {
            showSearchBar()
        }
    }
    
    private func hideSearchBar() {
        guard self.searchBarTopConstraint?.isActive == true else { return }
        
        self.searchBarTopConstraint?.deactivate()
        searchBar.snp.makeConstraints { make in
            self.searchBarTopConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).constraint
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func showSearchBar() {
        guard self.searchBarTopConstraint?.isActive == false else { return }

        self.searchBarTopConstraint?.deactivate()
        searchBar.snp.makeConstraints { make in
            self.searchBarTopConstraint = make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8).constraint
        }

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

