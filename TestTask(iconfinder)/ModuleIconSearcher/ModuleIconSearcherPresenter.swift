//
//  ModuleIconSearcherPresenter.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

protocol ModuleIconSearcherPresenterProtocol: AnyObject {
    func searchIcons(with text: String)
    func loadImage(imageURL: String) async throws -> UIImage
    func saveIconToGallery(image: UIImage)
}

final class ModuleIconSearcherPresenter: ModuleIconSearcherPresenterProtocol {
    
    weak var view: ModuleIconSearcherViewProtocol?
    private let iconSearchService: IconSearchServiceProtocol
    private let imageLoaderManager: ImageLoaderManagerProtocol
    private let debounceExecutor: CancellableExecutorProtocol
    private let iconSavingManager: IconSavingManagerProtocol
    private var icons: [IconModel]?
    
    required init(iconSearchService: IconSearchServiceProtocol, 
                  imageLoaderManager: ImageLoaderManagerProtocol,
                  debounceExecutor: CancellableExecutorProtocol,
                  iconSavingManager: IconSavingManagerProtocol)
    {
        self.iconSearchService = iconSearchService
        self.imageLoaderManager = imageLoaderManager
        self.debounceExecutor = debounceExecutor
        self.iconSavingManager = iconSavingManager
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
    
    func loadImage(imageURL: String) async throws -> UIImage {
        try await imageLoaderManager.loadImage(from: imageURL)
    }
    
    func saveIconToGallery(image: UIImage) {
        iconSavingManager.saveToGallery(image: image)
    }
}

extension ModuleIconSearcherPresenter {
    
    func updateUI() {
        guard let icons = icons, icons.count > 0 else { return }
        let items: [ModuleIconSearcherTableViewCell.Model] = icons.map { icon in
            let imageURL = icon.sizes.last?.formats.last?.previewURL ?? ""
            let tags = "Tags: \(icon.tags.prefix(10).joined(separator: ", "))"
            
            var sizeLabel = "No format available"
            if let width = icon.sizes.last?.width, let height = icon.sizes.last?.height {
                sizeLabel = "\(width)x\(height)"
            }
            
            let loadImageAction: (String) async throws -> UIImage? = { [weak self] imageURL in
                guard let self = self else { return UIImage(systemName: "photo") }
                return try await self.loadImage(imageURL: imageURL)
            }
            
            let saveIconAction: (UIImage) -> Void = { [weak self] image in
                self?.iconSavingManager.saveToGallery(image: image)
            }
            
            return .init(
                imageURL: imageURL,
                tags: tags,
                sizeLabel: sizeLabel,
                loadImageAction: loadImageAction, 
                iconSavingAction: saveIconAction
            )
        }
        
        let model: ModuleIconSearcherView.Model = .init(items: items)
        DispatchQueue.main.async {
            self.view?.update(model: model)
        }
    }
}
