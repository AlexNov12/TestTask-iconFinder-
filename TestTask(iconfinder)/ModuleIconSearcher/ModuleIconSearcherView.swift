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
    }
    
    private var model: Model?
    private var isLoadingMoreData = false
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 48) / 2, height: 250)
        layout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ModuleIconSearcherCollectionViewCell.self, forCellWithReuseIdentifier: ModuleIconSearcherCollectionViewCell.iconCell)
        view.register(
            LoadingFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingFooterView.identifier
        )
        view.backgroundColor = .systemBackground
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
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
        collectionView.isHidden = true
        bringSubviewToFront(errorView)
    }
    
    func showEmpty(for state: EmptyView.EmptyState) {
        hideLoading()
        emptyView.updateLabel(for: state)
        emptyView.isHidden = false
        collectionView.isHidden = true
        bringSubviewToFront(emptyView)
    }
    
    func showLoading() {
        loadingView.isHidden = false
        collectionView.isHidden = true
        bringSubviewToFront(loadingView)
    }
    
    func hideLoading() {
        loadingView.isHidden = true
    }
    
    func update(model: Model) {
        self.model = model
        self.collectionView.reloadData()
        self.emptyView.isHidden = true
        self.errorView.isHidden = true
        self.collectionView.isHidden = false
        self.hideLoading()
    }
    
    func setLoadingMore(_ isLoading: Bool) {
        isLoadingMoreData = isLoading
        collectionView.reloadSections(IndexSet(integer: 0))
    }
}

// MARK: - UICollectionViewDataSource
extension ModuleIconSearcherView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = model, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModuleIconSearcherCollectionViewCell.iconCell, for: indexPath) as? ModuleIconSearcherCollectionViewCell else {
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter, isLoadingMoreData {
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LoadingFooterView.identifier,
                for: indexPath
            ) as! LoadingFooterView
            return footerView
        }
        return UICollectionReusableView()
    }
}

// MARK: - UIScrollViewDelegate
extension ModuleIconSearcherView: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            presenter.loadMoreIconsIfNeeded()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ModuleIconSearcherView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return isLoadingMoreData ? CGSize(width: collectionView.bounds.width, height: 50) : .zero
    }
}

// MARK: - UICollectionViewDelegate
extension ModuleIconSearcherView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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
