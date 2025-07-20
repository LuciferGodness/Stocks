import UIKit
import SnapKit

class SearchSuggestionsView: UIView {

    private let popularLabel = UILabel()
    private let recentLabel = UILabel()
    
    private let popularStackView = UIStackView()
    private let recentStackView = UIStackView()

    var onSuggestionTapped: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .systemBackground
        
        popularLabel.text = "Popular requests"
        popularLabel.font = .boldSystemFont(ofSize: 24)
        
        recentLabel.text = "You've searched for this"
        recentLabel.font = .boldSystemFont(ofSize: 24)

        popularStackView.axis = .vertical
        popularStackView.spacing = 10
        popularStackView.alignment = .leading
        
        recentStackView.axis = .vertical
        recentStackView.spacing = 10
        recentStackView.alignment = .leading
    }

    private func layoutViews() {
        addSubview(popularLabel)
        addSubview(popularStackView)
        addSubview(recentLabel)
        addSubview(recentStackView)

        popularLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.right.equalToSuperview().inset(16)
        }

        popularStackView.snp.makeConstraints { make in
            make.top.equalTo(popularLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        recentLabel.snp.makeConstraints { make in
            make.top.equalTo(popularStackView.snp.bottom).offset(28)
            make.left.right.equalToSuperview().inset(16)
        }

        recentStackView.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
    }

    func configure(popular: [String], recent: [String]) {
        popularStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        recentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let popularButtons = popular.map { createSuggestionButton(title: $0) }
        let popularRows = groupButtonsIntoRows(buttons: popularButtons)
        popularRows.forEach { popularStackView.addArrangedSubview($0) }

        let recentButtons = recent.map { createSuggestionButton(title: $0) }
        let recentRows = groupButtonsIntoRows(buttons: recentButtons)
        recentRows.forEach { recentStackView.addArrangedSubview($0) }
    }
    
    private func groupButtonsIntoRows(buttons: [UIButton]) -> [UIStackView] {
        var rows: [UIStackView] = []
        var currentRow = createRowStackView()
        var currentRowWidth: CGFloat = 0

        for button in buttons {
            button.sizeToFit()
            let buttonWidth = button.frame.width

            if currentRowWidth + buttonWidth > (UIScreen.main.bounds.width - 32) && !currentRow.arrangedSubviews.isEmpty {
                rows.append(currentRow)
                currentRow = createRowStackView()
                currentRowWidth = 0
            }
            
            currentRow.addArrangedSubview(button)
            currentRowWidth += buttonWidth + 10
        }
        rows.append(currentRow)
        return rows
    }

    private func createRowStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
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
}
