//
//  SegmentSwitcherView.swift
//  Stocks
//
//  Created by Admin on 7/21/25.
//

import UIKit

final class SegmentSwitcherView: UIView {
    private let stackView = UIStackView()
    private let stocksLabel = UILabel()
    private let favouriteLabel = UILabel()

    var onSegmentChanged: ((Int) -> Void)?

    private var activeLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        switchTo(label: stocksLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemBackground
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .bottom
        stackView.distribution = .fill

        [stocksLabel, favouriteLabel].forEach { label in
            label.isUserInteractionEnabled = true
            label.textColor = .systemGray
            label.font = .systemFont(ofSize: 22, weight: .medium)

            let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
            label.addGestureRecognizer(tap)
        }

        stocksLabel.text = "Stocks"
        favouriteLabel.text = "Favourite"

        stackView.addArrangedSubview(stocksLabel)
        stackView.addArrangedSubview(favouriteLabel)

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().offset(-16)
        }
    }

    @objc private func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let tapped = gesture.view as? UILabel else { return }
        switchTo(label: tapped)

        let index = (tapped == stocksLabel) ? 0 : 1
        onSegmentChanged?(index)
    }

    private func switchTo(label: UILabel) {
        activeLabel = label
        UIView.animate(withDuration: 0.3) {
            self.stocksLabel.font = (self.activeLabel == self.stocksLabel) ? .boldSystemFont(ofSize: 32) : .systemFont(ofSize: 22, weight: .medium)
            self.stocksLabel.textColor = (self.activeLabel == self.stocksLabel) ? .label : .systemGray

            self.favouriteLabel.font = (self.activeLabel == self.favouriteLabel) ? .boldSystemFont(ofSize: 32) : .systemFont(ofSize: 22, weight: .medium)
            self.favouriteLabel.textColor = (self.activeLabel == self.favouriteLabel) ? .label : .systemGray
        }
    }
}
