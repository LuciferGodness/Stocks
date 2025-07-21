import UIKit
import SnapKit

final class SearchSuggestionsView: UIView {
    private let popularLabel = SearchSuggestionsView.makeSectionLabel(text: "Popular requests")
    private let recentLabel = SearchSuggestionsView.makeSectionLabel(text: "You've searched for this")
    
    private let popularStackView = SearchSuggestionsView.makeVerticalStack()
    private let recentStackView = SearchSuggestionsView.makeVerticalStack()

    var onSuggestionTapped: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }

    private func setupLayout() {
        [popularLabel, popularStackView, recentLabel, recentStackView].forEach(addSubview)
        
        popularLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.left.right.equalToSuperview().inset(16)
        }

        popularStackView.snp.makeConstraints {
            $0.top.equalTo(popularLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
        }

        recentLabel.snp.makeConstraints {
            $0.top.equalTo(popularStackView.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(16)
        }

        recentStackView.snp.makeConstraints {
            $0.top.equalTo(recentLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    
    func configure(popular: [String], recent: [String]) {
        configureStackView(popularStackView, with: popular)
        configureStackView(recentStackView, with: recent)
    }

    private func configureStackView(_ stackView: UIStackView, with suggestions: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let buttons = suggestions.map(createSuggestionButton)
        let rows = groupButtonsIntoRows(buttons: buttons)
        rows.forEach { stackView.addArrangedSubview($0) }
    }

    private func groupButtonsIntoRows(buttons: [UIButton]) -> [UIStackView] {
        var rows: [UIStackView] = []
        var currentRow = SearchSuggestionsView.makeHorizontalStack()
        var currentRowWidth: CGFloat = 0
        let maxRowWidth = UIScreen.main.bounds.width - 32

        for button in buttons {
            button.sizeToFit()
            let buttonWidth = button.frame.width

            if currentRowWidth + buttonWidth > maxRowWidth && !currentRow.arrangedSubviews.isEmpty {
                rows.append(currentRow)
                currentRow = SearchSuggestionsView.makeHorizontalStack()
                currentRowWidth = 0
            }

            currentRow.addArrangedSubview(button)
            currentRowWidth += buttonWidth + 10
        }

        rows.append(currentRow)
        return rows
    }

    private func createSuggestionButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.addTarget(self, action: #selector(suggestionTapped(_:)), for: .touchUpInside)
        return button
    }

    @objc private func suggestionTapped(_ sender: UIButton) {
        guard let text = sender.title(for: .normal) else { return }
        onSuggestionTapped?(text)
    }

    private static func makeSectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }

    private static func makeVerticalStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        return stack
    }

    private static func makeHorizontalStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .leading
        return stack
    }
}

