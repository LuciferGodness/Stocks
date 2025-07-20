//
//  SearchBar.swift
//  Stocks
//
//  Created by Admin on 7/21/25.
//

import UIKit

final class CustomSearchBar: UISearchBar {
    private let backButton = UIButton(type: .system)
    private let backButtonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    private let magnifyingGlassContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
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
        self.placeholder = "Find company or ticker"
        self.searchBarStyle = .minimal
        self.barTintColor = .white
        self.backgroundColor = .white
        self.backgroundImage = UIImage()
        
        guard let textField = self.value(forKey: "searchField") as? UITextField else { return }
        
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = 25
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.clipsToBounds = true
        textField.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        let clearImage = UIImage()
        self.setSearchFieldBackgroundImage(clearImage, for: .normal)
        self.setBackgroundImage(clearImage, for: .any, barMetrics: .default)
        
        backButton.setImage(AppImages.backBtn.image, for: .normal)
        backButton.tintColor = .black
        backButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.center = backButtonContainer.center
        backButtonContainer.addSubview(backButton)
        backButtonContainer.isHidden = true
        
        if let imageView = textField.leftView as? UIImageView {
            imageView.tintColor = .black
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 12, y: 12, width: 20, height: 20)
            
            magnifyingGlassImageView.frame = imageView.frame
            magnifyingGlassImageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            magnifyingGlassImageView.tintColor = .black
            
            magnifyingGlassContainer.addSubview(magnifyingGlassImageView)
        }
        
        textField.leftView = magnifyingGlassContainer
        textField.leftViewMode = .always
    }

    @objc private func backButtonTapped() {
        self.endEditing(true)
        self.text = ""
        self.delegate?.searchBarCancelButtonClicked?(self)
        hideBackButton()
    }

    func showBackButton() {
        guard let textField = self.value(forKey: "searchField") as? UITextField else { return }
        backButton.isHidden = false
        backButtonContainer.isHidden = false
        
        textField.leftView = backButtonContainer
        textField.leftViewMode = .always
    }

    func hideBackButton() {
        guard let textField = self.value(forKey: "searchField") as? UITextField else { return }
        backButton.isHidden = true
        backButtonContainer.isHidden = true
        
        textField.leftView = magnifyingGlassContainer
        textField.leftViewMode = .always
    }
}
