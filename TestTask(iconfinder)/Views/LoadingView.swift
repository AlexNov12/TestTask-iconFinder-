//
//  LoadingView.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 30.09.2024.
//

import UIKit

final class LoadingView: UIView {

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.style = .medium
        loadingIndicator.color = .systemBlue
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        loadingIndicator.accessibilityIdentifier = "loadingId"
        loadingIndicator.isAccessibilityElement = true
        return loadingIndicator
    }()

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LoadingView {

    func commonInit() {
        backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(loadingIndicator)
    }

    func setupConstraints() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
