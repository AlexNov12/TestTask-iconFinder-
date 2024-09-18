//
//  MainImageTableViewCell.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    static let reuseID = "ImageTableViewCell"
    
    var id: Int?
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    lazy var sizeLabel: UILabel = {
        let sizeLabel = UILabel()
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.numberOfLines = 0
        return sizeLabel
    }()
    
    lazy var tagsLabel: UILabel = {
        let tagsLabel = UILabel()
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsLabel.numberOfLines = 0
        return tagsLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(tagsLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
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
    
    func configure(icon: IconModel) {
        id = icon.icon_id
        
        if let urlString = icon.raster_sizes.last?.formats.last?.preview_url {
            ImageLoaderManager.shared.loadImage(from: urlString) { [weak self] image in
                DispatchQueue.main.async {
                    self?.iconImageView.image = image
                }
            }
        }
    }
    
    @objc private func imageTapped() {
        guard let image = iconImageView.image else { return }
        PhotoLibraryManager.shared.writeToPhotoAlbum(image: image)
    }
}
