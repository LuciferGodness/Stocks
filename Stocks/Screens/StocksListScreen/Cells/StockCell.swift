import UIKit
import SnapKit
import Combine

class StockCell: UITableViewCell {
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
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupViews()
        layoutViews()
        setupFavoriteTap()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        [logoImageView, infoStack, favoriteImageView, priceStack].forEach { containerView.addSubview($0) }

        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.left.right.equalToSuperview().inset(16)
        }

        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }

        infoStack.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }

        favoriteImageView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(8)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(16)
            make.height.equalTo(18)
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

    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
        imageCancellable?.cancel()
        onFavoriteButtonTapped = nil
    }

    func configure(with stock: StocksDTO, isFavorite: Bool, imageService: ImageServiceProtocol, backgroundColor: UIColor) {
        titleLabel.text = stock.symbol
        subtitleLabel.text = stock.name
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .decimal
        priceFormatter.groupingSeparator = " "
        priceFormatter.decimalSeparator = "."
        priceFormatter.minimumFractionDigits = 0
        priceFormatter.maximumFractionDigits = 2
        
        if let formattedPrice = priceFormatter.string(from: NSNumber(value: stock.price)) {
            priceLabel.text = "$" + formattedPrice
        }
        
        let sign = stock.change >= 0 ? "+" : "−"
        let dollarChange = String(format: "%.2f", abs(stock.change))
        let percentChange = String(format: "%.2f", abs(stock.changePercent)).replacingOccurrences(of: ".", with: ",")
        changeLabel.text = "\(sign)$\(dollarChange) (\(percentChange)%)"
        changeLabel.textColor = stock.change >= 0 ? .systemGreen : .systemRed
        
        favoriteImageView.image = isFavorite ? AppImages.favourite.image : AppImages.unfavourite.image
        
        containerView.backgroundColor = backgroundColor
        
        imageCancellable = imageService.loadImage(from: URL(string: stock.logo)!)
            .sink { [weak self] image in
                self?.logoImageView.image = image ?? UIImage(systemName: "photo")
            }
    }
}
