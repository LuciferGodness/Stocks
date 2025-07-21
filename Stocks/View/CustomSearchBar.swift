//
//  SearchBar.swift
//  Stocks
//
//  Created by Admin on 7/21/25.
//

import UIKit

final class CustomSearchBar: UISearchBar {
    private let backButton = UIButton(type: .system)
    private let backButtonContainer = UIView(frame: .init(x: 0, y: 0, width: 44, height: 44))
    
    private let magnifyingGlassContainer = UIView(frame: .init(x: 0, y: 0, width: 44, height: 44))
    private let magnifyingGlassImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }

    private func setupStyle() {
        configureSearchBarAppearance()
        configureTextField()
        configureBackButton()
        configureMagnifyingGlass()
    }

    private func configureSearchBarAppearance() {
        placeholder = "Find company or ticker"
        searchBarStyle = .minimal
        barTintColor = .white
        backgroundColor = .white
        backgroundImage = UIImage()
        setSearchFieldBackgroundImage(UIImage(), for: .normal)
        setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }

    private func configureTextField() {
        let textField = self.searchTextField

        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 17, weight: .medium)
        textField.layer.cornerRadius = 25
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.clipsToBounds = true
        textField.leftViewMode = .always
    }

    private func configureBackButton() {
        backButton.setImage(AppImages.backBtn.image, for: .normal)
        backButton.tintColor = .black
        backButton.frame.size = CGSize(width: 36, height: 36)
        backButton.center = backButtonContainer.center
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        backButtonContainer.addSubview(backButton)
        backButtonContainer.isHidden = true
    }

    private func configureMagnifyingGlass() {
        guard let image = AppImages.searchIcon.image?.withRenderingMode(.alwaysTemplate) else { return }

        magnifyingGlassImageView.image = image
        magnifyingGlassImageView.tintColor = .black
        magnifyingGlassImageView.contentMode = .scaleAspectFit
        magnifyingGlassImageView.frame = CGRect(x: 12, y: 12, width: 24, height: 24)

        magnifyingGlassContainer.addSubview(magnifyingGlassImageView)
        searchTextField.leftView = magnifyingGlassContainer
    }

    @objc private func backButtonTapped() {
        endEditing(true)
        text = ""
        delegate?.searchBarCancelButtonClicked?(self)
        hideBackButton()
    }

    func showBackButton() {
        updateLeftView(using: backButtonContainer, show: true)
    }

    func hideBackButton() {
        updateLeftView(using: magnifyingGlassContainer, show: false)
    }

    private func updateLeftView(using view: UIView, show: Bool) {
        backButton.isHidden = !show
        backButtonContainer.isHidden = !show
        searchTextField.leftView = view
    }
}
