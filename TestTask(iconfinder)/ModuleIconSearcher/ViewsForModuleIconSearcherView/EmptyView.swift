//
//  EmptyView.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 30.09.2024.
//

import UIKit

final class EmptyView: UIView {

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing was found."
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with text: String) {
        messageLabel.text = text
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
    }

    func setupConstraints() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

