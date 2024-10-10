//
//  ModuleIconSearcherCollectionViewCell.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 05.10.2024.
//

import UIKit
import Nuke

final class ModuleIconSearcherCollectionViewCell: UICollectionViewCell {

    static let iconCell = "ModuleIconSearcherCollectionViewCell"
    private var task: ImageTask?

    struct Model {
        let imageURL: String
        let tags: String
        let sizeLabel: String
    }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        imageView.addGestureRecognizer(tapGesture)
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .systemGray
        return imageView
    }()

    private lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        return label
    }()

    private lazy var tagsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        iconImageView.image = UIImage(systemName: "photo")
        sizeLabel.text = nil
        tagsLabel.text = nil
    }

    func update(with model: Model) {
        loadImage(from: model.imageURL)
        sizeLabel.text = model.sizeLabel
        tagsLabel.text = model.tags
    }
}

private extension ModuleIconSearcherCollectionViewCell {

    func loadImage(from urlString: String) {
        prepareForReuse()

        guard let url = URL(string: urlString) else {
            iconImageView.image = nil
            return
        }

        if let image = ImagePipeline.shared.cache.cachedImage(for: ImageRequest(url: url))?.image {
            self.iconImageView.image = image
            return
        }
        task = ImagePipeline.shared.loadImage(with: url) { [weak self] result in
            switch result {
            case .success(let response):
                self?.iconImageView.image = response.image
            case .failure:
                self?.iconImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
            }
        }
    }

    @objc func imageClicked() {
        guard let image = iconImageView.image else { return }
        SavingManager.shared.saveToGallery(image: image)
    }

    func setupSubviews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(tagsLabel)
        setupConstraints()
    }

    func setupConstraints() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            iconImageView.heightAnchor.constraint(equalToConstant: 150),

            sizeLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            sizeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            sizeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            tagsLabel.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: 8),
            tagsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tagsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            tagsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
