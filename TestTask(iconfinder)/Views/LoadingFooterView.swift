//
//  LoadingFooterView.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 05.10.2024.
//

import UIKit

final class LoadingFooterView: UICollectionReusableView {

    static let identifier = "LoadingFooterView"

    private lazy var footerIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.hidesWhenStopped = true
        indicator.color = .red
        indicator.isAccessibilityElement = true
        indicator.startAnimating()
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LoadingFooterView {

    func commonInit() {
        backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(footerIndicator)
    }

    func setupConstraints() {
        footerIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            footerIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            footerIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
