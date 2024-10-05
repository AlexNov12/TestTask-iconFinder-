//
//  EmptyView.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 30.09.2024.
//

import UIKit

final class EmptyView: UIView {

    enum EmptyState {
        case emptyState
        case emptySearchState
    }

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "It's empty. Start the search."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabel(for state: EmptyState) {
        switch state {
            case .emptyState:
                messageLabel.text = "It's empty. Start the search."
                placeholderImageView.image = UIImage(systemName: "photo")
            case .emptySearchState:
                messageLabel.text = "No result. Try another one."
                placeholderImageView.image = UIImage(systemName: "minus.magnifyingglass")
        }
    }
}

private extension EmptyView {

    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(messageLabel)
        addSubview(placeholderImageView)
    }

    func setupConstraints() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -32),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            placeholderImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderImageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 40),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 40),
            placeholderImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
}
