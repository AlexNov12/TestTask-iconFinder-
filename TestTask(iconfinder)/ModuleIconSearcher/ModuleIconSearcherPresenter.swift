//
//  ModuleIconSearcherPresenter.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

protocol ModuleIconSearcherPresenterProtocol {
    func searchIcons(with text: String)
    func loadMoreIcons()
    func retryLoading()
}

final class ModuleIconSearcherPresenter: ModuleIconSearcherPresenterProtocol {

    weak var view: ModuleIconSearcherViewProtocol?
    private let iconSearchService: IconSearchServiceProtocol
    private let debounceExecutor: CancellableExecutorProtocol
    private var icons: [IconResponse.IconModel] = []

    private let pageSize = 10
    private var isLoading = false
    private var currentQuery: String = ""
    private var totalIconsCount = 0
    private var currentOffset = 0

    required init(iconSearchService: IconSearchServiceProtocol, debounceExecutor: CancellableExecutorProtocol) {
        self.iconSearchService = iconSearchService
        self.debounceExecutor = debounceExecutor
    }

    func searchIcons(with text: String) {
        icons.removeAll()

        guard !text.isEmpty else {
            view?.showEmpty(for: .emptyState)
            return
        }

        currentQuery = text
        currentOffset = 0
        totalIconsCount = 0

        view?.update(model: .init(items: []))
        view?.showLoading()

        debounceExecutor.execute(delay: .milliseconds(1000)) { [weak self] isCancelled in
            guard let self = self, !isCancelled.isCancelled else { return }
            self.loadIcons()
        }
    }

    func loadMoreIcons() {
        guard icons.count < totalIconsCount else { return }
        loadIcons()
    }

    func retryLoading() {
        loadIcons()
    }
}

private extension ModuleIconSearcherPresenter {

    func loadIcons() {
        guard !isLoading, !currentQuery.isEmpty else {
            return
        }
        isLoading = true

        if !icons.isEmpty {
            view?.setLoadingMore(true)
        }

        iconSearchService.searchIcons(
            query: currentQuery,
            count: pageSize,
            offset: currentOffset
        ) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                self.view?.hideLoading()
                if !self.icons.isEmpty {
                    self.view?.setLoadingMore(false)
                }

                switch result {
                case .success(let response):
                    self.totalIconsCount = response.totalCount
                    self.icons.append(contentsOf: response.icons)
                    self.currentOffset += self.pageSize
                    self.updateUI()
                case .failure(let error):
                    print("Error fetching icons: \(error)")
                    self.view?.showError()
                }
            }
        }
    }

    func updateUI() {
        guard !icons.isEmpty else {
            view?.showEmpty(for: .emptySearchState)
            return
        }
        let items: [ModuleIconSearcherCollectionViewCell.Model] = icons.map { icon in
            let imageURL = icon.sizes.last?.formats.last?.previewURL ?? ""
            let sizeLabel: String
            if let width = icon.sizes.last?.width, let height = icon.sizes.last?.height {
                sizeLabel = "\(width)x\(height)"
            } else {
                sizeLabel  = "No format available"
            }

            return .init(
                imageURL: imageURL,
                tags: "Tags: \(icon.tags.prefix(10).joined(separator: ", "))",
                sizeLabel: sizeLabel
            )
        }

        let model: ModuleIconSearcherView.Model = .init(items: items)
        view?.update(model: model)
    }
}
