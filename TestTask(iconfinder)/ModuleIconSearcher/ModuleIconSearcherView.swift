//
//  ModuleIconSearcherView.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

final class ModuleIconSearcherView: UIView {

    typealias Item = ModuleIconSearcherCollectionViewCell.Model

    struct Model {
        let items: [Item]
        let onRequestData: ((Int) -> Void)?
    }

    private var model: Model?
    private var isLoadingMoreData = false
    private var onRequestData: ((Int) -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 48) / 2, height: 250)

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(
            ModuleIconSearcherCollectionViewCell.self,
            forCellWithReuseIdentifier: ModuleIconSearcherCollectionViewCell.iconCell
        )
        view.backgroundColor = .systemBackground
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.prefetchDataSource = self
        return view
    }()

    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.isHidden = true
        return view
    }()

    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.isHidden = true
        view.delegate = self
        return view
    }()

    private lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.isHidden = true
        return view
    }()

    private let presenter: ModuleIconSearcherPresenterProtocol

    init(presenter: ModuleIconSearcherPresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showError() {
        hideLoading()
        errorView.isHidden = false
        bringSubviewToFront(errorView)
    }

    func showEmpty(for state: EmptyView.EmptyState) {
        hideLoading()
        emptyView.updateState(for: state)
        emptyView.isHidden = false
        bringSubviewToFront(emptyView)
    }

    func showLoading() {
        loadingView.isHidden = false
        bringSubviewToFront(loadingView)
    }

    func hideLoading() {
        loadingView.isHidden = true
    }

    func update(model: Model) {
        self.model = model
        self.onRequestData = model.onRequestData
        collectionView.reloadData()
        emptyView.isHidden = true
        errorView.isHidden = true
        hideLoading()
    }

    func setLoadingMore(_ isLoading: Bool) {
        isLoadingMoreData = isLoading
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ModuleIconSearcherView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.items.count ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let model = model,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ModuleIconSearcherCollectionViewCell.iconCell, for: indexPath)
                as? ModuleIconSearcherCollectionViewCell else {
            return UICollectionViewCell()
        }

        let item = model.items[indexPath.item]
        let cellModel = ModuleIconSearcherCollectionViewCell.Model(
            imageURL: item.imageURL,
            tags: item.tags,
            sizeLabel: item.sizeLabel
        )

        cell.update(with: cellModel)
        return cell
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension ModuleIconSearcherView: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let rows = indexPaths.map { $0.row }
        guard let index = rows.max() else { return }
        print("Prefetching data for index \(index)")
        model?.onRequestData?(index)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ModuleIconSearcherView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

private extension ModuleIconSearcherView {

    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        addSubview(collectionView)
        addSubview(loadingView)
        addSubview(errorView)
        addSubview(emptyView)
    }

    func setupConstraints() {

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),

            errorView.topAnchor.constraint(equalTo: topAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),

            emptyView.topAnchor.constraint(equalTo: topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension ModuleIconSearcherView: ErrorViewDelegate {
    func didTapRetry() {
        presenter.retryLoading()
    }
}
