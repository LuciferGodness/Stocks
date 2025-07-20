//
//  Eventcell.swift
//  EventTracker
//
//  Created by Admin on 7/2/25.
//

import UIKit
import SnapKit

class StockCell: UITableViewCell {
    let logo = UIImageView()
    let title = UILabel()
    let subtitle = UILabel()
    let price = UILabel()
    let change = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [logo, title, subtitle, price, change].forEach {
            contentView.addSubview($0)
        }
        
        logo.snp.makeConstraints { $0.size.equalTo(40) }
        title.font = .boldSystemFont(ofSize: 16)
        subtitle.font = .systemFont(ofSize: 12)
        subtitle.textColor = .gray
        
        let infoStack = UIStackView(arrangedSubviews: [title, subtitle])
        infoStack.axis = .vertical
        infoStack.spacing = 2
        contentView.addSubview(infoStack)
        infoStack.snp.makeConstraints { make in
            make.left.equalTo(logo.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }

        price.font = .boldSystemFont(ofSize: 16)
        change.font = .systemFont(ofSize: 12)
        change.textColor = .systemGreen
        let priceStack = UIStackView(arrangedSubviews: [price, change])
        priceStack.axis = .vertical
        priceStack.spacing = 2
        contentView.addSubview(priceStack)
        priceStack.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with stock: StocksDTO) {
//        logo.image = UIImage(named: stock.logoName)
        title.text = stock.symbol
        subtitle.text = stock.name
        price.text = "$\(stock.price)"
        change.text = "+$\(stock.change) (\(stock.changePercent)%)"
    }
}

