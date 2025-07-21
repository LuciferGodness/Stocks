//
//  SearchResultsHeaderView.swift
//  Stocks
//
//  Created by Admin on 7/21/25.
//

import UIKit
import SnapKit

final class SearchResultsHeaderView: UIView {
    private let titleLabel = UILabel()
    let showMoreButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemBackground
        titleLabel.text = "Stocks"
        titleLabel.font = .boldSystemFont(ofSize: 20)

        showMoreButton.setTitle("Show more", for: .normal)
        showMoreButton.setTitleColor(.black, for: .normal)

        addSubview(titleLabel)
        addSubview(showMoreButton)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        showMoreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
