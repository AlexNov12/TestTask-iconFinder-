//
//  ModuleIconSearcherTableViewCell.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit
import Nuke

final class ModuleIconSearcherTableViewCell: UITableViewCell {
    
    static let iconCell = "ModuleIconSearcherTableViewCell"
    
    struct Model {
        let imageURL: String
        let tags: String
        let sizeLabel: String
        let loadImageAction: (String) async throws -> UIImage?
        let iconSavingAction: (UIImage) -> Void
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private lazy var tagsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private var iconSavingAction: ((UIImage) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        backgroundColor = .systemBackground
        selectionStyle = .none
        tintColor = .systemRed
        
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: Model) {
        sizeLabel.text = model.sizeLabel
        tagsLabel.text = model.tags
        self.iconSavingAction = model.iconSavingAction
        Task { [weak self] in
            guard let self = self else { return }
            do {
                if let image = try await model.loadImageAction(model.imageURL) {
                    iconImageView.image = image
                }
            } catch {
                iconImageView.image = UIImage(systemName: "photo")
                print("Error loading image: \(error)")
            }
        }
    }
    
    @objc private func imageClicked() {
        guard let image = iconImageView.image else { return }
        iconSavingAction?(image)
    }
}

private extension ModuleIconSearcherTableViewCell {
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
            iconImageView.heightAnchor.constraint(equalToConstant: 200),
            
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
