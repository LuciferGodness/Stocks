//
//  Eventcell.swift
//  EventTracker
//
//  Created by Admin on 7/2/25.
//

import UIKit
import SnapKit
import Combine

class StockCell: UITableViewCell {
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let priceLabel = UILabel()
    let changeLabel = UILabel()
    
    private var cancellable: AnyCancellable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupViews() {
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.layer.cornerRadius = 8
        logoImageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        
        priceLabel.font = .boldSystemFont(ofSize: 18)
        priceLabel.textAlignment = .right
        changeLabel.font = .systemFont(ofSize: 12)
        changeLabel.textAlignment = .right
    }
    
    private func layoutViews() {
        contentView.addSubview(logoImageView)
        let infoStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 2
        contentView.addSubview(infoStack)
        
        let priceStack = UIStackView(arrangedSubviews: [priceLabel, changeLabel])
        priceStack.axis = .vertical
        priceStack.spacing = 2
        contentView.addSubview(priceStack)
        
        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
        }
        
        infoStack.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(priceStack.snp.left).offset(-12)
        }
        
        priceStack.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
        cancellable?.cancel()
    }
    
    func configure(with stock: StocksDTO, imageService: ImageServiceProtocol) {
        titleLabel.text = stock.symbol
        subtitleLabel.text = stock.name
        
        // Format Price
        priceLabel.text = String(format: "$%.2f", stock.price)
        
        // Format Change
        let changeValue = stock.change
        let percentValue = stock.changePercent
        let sign = changeValue >= 0 ? "+" : ""
        let changeText = String(format: "%@$%.2f (%.2f%%)", sign, abs(changeValue), percentValue).replacingOccurrences(of: ".", with: ",")
        changeLabel.text = changeText
        changeLabel.textColor = changeValue >= 0 ? .systemGreen : .systemRed
        
        // Load Image
        if let url = URL(string: stock.logo) {
            cancellable = imageService.loadImage(from: url)
                .sink { [weak self] image in
                    self?.logoImageView.image = image ?? UIImage(systemName: "photo") // Placeholder
                }
        }
    }
}
