//
//  EventListView.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//

import UIKit
import SnapKit

class StocksListView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let searchBar = UISearchBar()
    let segmentedControl = UISegmentedControl(items: ["Stocks", "Favourite"])
    let tableView = UITableView()
    
    var viewModel: StocksListViewModel!
    
    init(viewModel: StocksListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List"
        view.backgroundColor = .systemBackground
        
        setupViews()
        layoutViews()
        
        viewModel.send(.appear)
    }
    
    func setupViews() {
        searchBar.placeholder = "Find company or ticker"
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StockCell.self, forCellReuseIdentifier: "StockCell")
        view.addSubview(tableView)
    }
    
    func layoutViews() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
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
    
    @objc func segmentChanged() {
        tableView.reloadData()
    }

    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let allStocks = viewModel.state.stocks
        return allStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as? StockCell else {
            return UITableViewCell()
        }
        
        let stocks = viewModel.state.stocks
        
        cell.configure(with: stocks[indexPath.row])
        return cell
    }
}

