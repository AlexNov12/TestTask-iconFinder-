//
//  ModuleIconSearcherPresenter.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

protocol ModuleIconSearcherPresenterProtocol {
    func searchIcons(with text: String)
}

final class ModuleIconSearcherPresenter: ModuleIconSearcherPresenterProtocol {
    weak var view: ModuleIconSearcherViewProtocol?
    private let iconSearchService: IconSearchServiceProtocol
    private let imageLoaderManager: ImageLoaderManagerProtocol
    private let debounceExecutor: CancellableExecutorProtocol
    private var icons: [IconModel]?
    
    required init(iconSearchService: IconSearchServiceProtocol, imageLoaderManager: ImageLoaderManagerProtocol, debounceExecutor: CancellableExecutorProtocol) {
        self.iconSearchService = iconSearchService
        self.imageLoaderManager = imageLoaderManager
        self.debounceExecutor = debounceExecutor
    }
    
    func searchIcons(with text: String) {
        debounceExecutor.execute(delay: .milliseconds(1000)) { [weak self] isCancelled in
            guard !isCancelled.isCancelled else { return }
            self?.iconSearchService.searchIcons(query: text) { [weak self] (result: Result<[IconModel], Error>) in
                guard let self else { return }
                switch result {
                case let .success(icons):
                    self.icons = icons
                    updateUI()
                case let .failure(error):
                    print("Error fetching icons: \(error)")
                }
            }
        }
    }
}

private extension ModuleIconSearcherPresenter {
    
    func updateUI() {
        guard let icons = icons, icons.count > 0 else { return }
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
        }
    }
}
