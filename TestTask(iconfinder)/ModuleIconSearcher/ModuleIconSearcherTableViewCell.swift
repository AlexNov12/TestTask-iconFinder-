//
//  ModuleIconSearcherTableViewCell.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

final class ModuleIconSearcherTableViewCell: UITableViewCell {
    
   static let iconCell = "ModuleIconSearcherTableViewCell"
   
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
        return imageView
   }()
   
   private lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
   }()
   
   private lazy var tagsLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
   }()
   
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
        loadImage(from: model.imageURL)
        sizeLabel.text = model.sizeLabel
        tagsLabel.text = model.tags
    }
    
    private func loadImage(from urlString: String) {
        guard let _ = URL(string: urlString) else {
            iconImageView.image = nil
            return
        }
        
        ImageLoaderManager.shared.loadImage(from: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.iconImageView.image = image
            }
        }
    }
    
    @objc private func imageClicked() {
        guard let image = iconImageView.image else { return }
        IconSavingManager.shared.saveToGallery(image: image)
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
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 200),
            
            sizeLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            sizeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            sizeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            tagsLabel.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: 8),
            tagsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tagsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}
