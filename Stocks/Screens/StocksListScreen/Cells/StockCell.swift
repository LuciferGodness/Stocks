import UIKit
import SnapKit
import Combine

final class StockCell: UITableViewCell {
    private let containerView = UIView()
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()
    private let favoriteImageView = UIImageView()

    var onFavoriteButtonTapped: (() -> Void)?
    private var imageCancellable: AnyCancellable?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupViews()
        layoutViews()
        setupFavoriteTap()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
        imageCancellable?.cancel()
        onFavoriteButtonTapped = nil
    }

    func configure(with stock: StocksDTO, isFavorite: Bool, imageService: ImageServiceProtocol, backgroundColor: UIColor) {
        titleLabel.text = stock.symbol
        subtitleLabel.text = stock.name
        priceLabel.text = formatPrice(stock.price)
        
        changeLabel.text = formatChange(amount: stock.change, percent: stock.changePercent)
        changeLabel.textColor = stock.change >= 0 ? .systemGreen : .systemRed

        favoriteImageView.image = isFavorite ? AppImages.favourite.image : AppImages.unfavourite.image
        containerView.backgroundColor = backgroundColor

        if let url = URL(string: stock.logo) {
            imageCancellable = imageService.loadImage(from: url)
                .sink { [weak self] image in
                    self?.logoImageView.image = image ?? UIImage(systemName: "photo")
                }
        }
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    private func setupViews() {
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.layer.cornerRadius = 8
        logoImageView.clipsToBounds = true

        titleLabel.font = .boldSystemFont(ofSize: 18)
        subtitleLabel.font = .systemFont(ofSize: 12)

        priceLabel.font = .boldSystemFont(ofSize: 18)
        priceLabel.textAlignment = .right

        changeLabel.font = .systemFont(ofSize: 12)
        changeLabel.textAlignment = .right

        favoriteImageView.contentMode = .scaleAspectFit
        favoriteImageView.isUserInteractionEnabled = true
    }

    private func layoutViews() {
        let infoStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 2
        infoStack.alignment = .leading

        let priceStack = UIStackView(arrangedSubviews: [priceLabel, changeLabel])
        priceStack.axis = .vertical
        priceStack.spacing = 2
        priceStack.alignment = .trailing

        [logoImageView, infoStack, favoriteImageView, priceStack].forEach {
            containerView.addSubview($0)
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }

        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
        }

        infoStack.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }

        favoriteImageView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(8)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 16, height: 18))
        }

        priceStack.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(favoriteImageView.snp.right).offset(8)
        }
    }

    private func setupFavoriteTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        favoriteImageView.addGestureRecognizer(tapGesture)
    }

    @objc private func favoriteTapped() {
        onFavoriteButtonTapped?()
    }

    private func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return "$" + (formatter.string(from: NSNumber(value: price)) ?? "–")
    }

    private func formatChange(amount: Double, percent: Double) -> String {
        let sign = amount >= 0 ? "+" : "−"
        let formattedAmount = String(format: "%.2f", abs(amount))
        let formattedPercent = String(format: "%.2f", abs(percent)).replacingOccurrences(of: ".", with: ",")
        return "\(sign)$\(formattedAmount) (\(formattedPercent)%)"
    }
}
