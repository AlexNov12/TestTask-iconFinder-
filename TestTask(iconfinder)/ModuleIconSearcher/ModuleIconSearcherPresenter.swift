//
//  ModuleIconSearcherPresenter.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

protocol ModuleIconSearcherPresenterProtocol {
    func searchIcons(with text: String)
    func loadMoreIconsIfNeeded()
    func retryLoading()
}

final class ModuleIconSearcherPresenter: ModuleIconSearcherPresenterProtocol {
    weak var view: ModuleIconSearcherViewProtocol?
    private let iconSearchService: IconSearchServiceProtocol
    private let debounceExecutor: CancellableExecutorProtocol
    private var icons: [IconModel] = []
    
    private var isLoading = false
    private var currentQuery: String = ""
    private var totalIconsCount = 0
    private var currentOffset = 0
    private let pageSize = 5
    
    required init(iconSearchService: IconSearchServiceProtocol, debounceExecutor: CancellableExecutorProtocol) {
        self.iconSearchService = iconSearchService
        self.debounceExecutor = debounceExecutor
    }
    
    func searchIcons(with text: String) {
        
        guard !text.isEmpty else {
            icons.removeAll()
            DispatchQueue.main.async {
                self.view?.update(model: .init(items: []))
            }
            return
        }
        
        currentQuery = text
        currentOffset = 0
        totalIconsCount = 0
        icons.removeAll()
        view?.update(model: .init(items: []))
        
        debounceExecutor.execute(delay: .milliseconds(1000)) { [weak self] isCancelled in
            guard let self = self, !isCancelled.isCancelled else { return }
            self.loadMoreIcons()
        }
    }
    
    func loadMoreIconsIfNeeded() {
        guard icons.count < totalIconsCount else { return }
        loadMoreIcons()
    }
    
    func retryLoading() {
        loadMoreIcons()
    }
}

private extension ModuleIconSearcherPresenter {
    
    func updateUI() {
        guard !icons.isEmpty else { return }
        let items: [ModuleIconSearcherTableViewCell.Model] = icons.map { icon in
            let imageURL = icon.sizes.last?.formats.last?.previewURL ?? ""
            var sizeLabel = "No format available"
            if let width = icon.sizes.last?.width, let height = icon.sizes.last?.height {
                sizeLabel = "\(width)x\(height)"
            }
            
            return .init(
                imageURL: imageURL,
                tags: "Tags: \(icon.tags.prefix(10).joined(separator: ", "))",
                sizeLabel: sizeLabel
            )
        }
        
        let model: ModuleIconSearcherView.Model = .init(items: items)
        DispatchQueue.main.async {
            self.view?.update(model: model)
            self.view?.hideLoading()
        }
    }
    
    func loadMoreIcons() {
        guard !isLoading, !currentQuery.isEmpty else { return }
        isLoading = true
        
        DispatchQueue.main.async {
            self.view?.showLoading()
        }
        
        iconSearchService.searchIcons(query: currentQuery, count: pageSize, offset: currentOffset) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            DispatchQueue.main.async {
                self.view?.hideLoading()
            }
            
            switch result {
            case .success(let response):
                self.totalIconsCount = response.totalCount
                self.icons.append(contentsOf: response.icons)
                self.currentOffset += self.pageSize
                if self.icons.isEmpty {
                    DispatchQueue.main.async {
                        self.view?.showEmpty(text: "No results found.")
                    }
                } else {
                    self.updateUI()
                }
            case .failure(let error):
                print("Error fetching icons: \(error)")
                DispatchQueue.main.async {
                    self.view?.hideLoading()
                    self.view?.showError()
                }
            }
        }
    }
}
