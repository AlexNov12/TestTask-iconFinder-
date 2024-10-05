//
//  ModuleIconSearcherView.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

final class ModuleIconSearcherView: UIView {
    
    typealias Item = ModuleIconSearcherTableViewCell.Model
    
    struct Model {
        let items: [Item]
    }
    
    private var model: Model?
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(ModuleIconSearcherTableViewCell.self, forCellReuseIdentifier: ModuleIconSearcherTableViewCell.iconCell)
        view.separatorInset = .zero
        view.tableFooterView = UIView()
        view.backgroundColor = .systemBackground
        view.separatorStyle = .none
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
        tableView.isHidden = true
        bringSubviewToFront(errorView)
    }
    
    func showEmpty(for state: EmptyView.EmptyState) {
        hideLoading()
        emptyView.updateLabel(for: state)
        emptyView.isHidden = false
        tableView.isHidden = true
        bringSubviewToFront(emptyView)
    }
    
    func showLoading() {
        loadingView.isHidden = false
        tableView.isHidden = true
        bringSubviewToFront(loadingView)
    }
    
    func hideLoading() {
        loadingView.isHidden = true
    }
    
    func update(model: Model) {
        self.model = model
        self.tableView.reloadData()
        self.emptyView.isHidden = true
        self.errorView.isHidden = true
        self.tableView.isHidden = false
        self.hideLoading()
    }
}

// MARK: - UITableViewDataSource
extension ModuleIconSearcherView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model, let cell = tableView.dequeueReusableCell(withIdentifier: ModuleIconSearcherTableViewCell.iconCell) as?
                ModuleIconSearcherTableViewCell else {
            return UITableViewCell()
        }
        
        let item = model.items[indexPath.row]
        
        let cellModel = ModuleIconSearcherTableViewCell.Model(
            imageURL: item.imageURL,
            tags: item.tags,
            sizeLabel: item.sizeLabel
        )
        
        cell.update(with: cellModel)
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension ModuleIconSearcherView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard model != nil else { return }
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if position > contentHeight - scrollView.frame.size.height * 4 {
            presenter.loadMoreIconsIfNeeded()
        }
    }
}

// MARK: - UITableViewDelegate
extension ModuleIconSearcherView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension ModuleIconSearcherView {
    
    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(tableView)
        addSubview(loadingView)
        addSubview(errorView)
        addSubview(emptyView)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
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
