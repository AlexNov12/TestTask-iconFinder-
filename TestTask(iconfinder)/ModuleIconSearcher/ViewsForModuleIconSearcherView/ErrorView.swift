//
//  ErrorView.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 30.09.2024.
//

import UIKit

protocol ErrorViewDelegate: AnyObject {
    func didTapRetry()
}

final class ErrorView: UIView {

    weak var delegate: ErrorViewDelegate?

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Something wrong. Retry again."
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        return button
    }()

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapRetry() {
        delegate?.didTapRetry()
    }
}

private extension ErrorView {

    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(messageLabel)
        addSubview(retryButton)
    }

    func setupConstraints() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
