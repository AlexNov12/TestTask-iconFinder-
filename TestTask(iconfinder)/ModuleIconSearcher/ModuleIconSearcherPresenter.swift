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
    private var icons: [IconModel]?
    
    required init(iconSearchService: IconSearchServiceProtocol, imageLoaderManager: ImageLoaderManagerProtocol) {
        self.iconSearchService = iconSearchService
        self.imageLoaderManager = imageLoaderManager
    }
    
    func searchIcons(with text: String) {
        iconSearchService.searchIcons(query: text) { [weak self] (result: Result<[IconModel], Error>) in
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

private extension ModuleIconSearcherPresenter {
    
    func updateUI() {
        guard let icons = icons, icons.count > 0 else { return }
        let items: [ModuleIconSearcherTableViewCell.Model] = icons.map { icon in
            let imageURL = icon.sizes.last?.formats.last?.previewURL ?? ""
            return .init(
                imageURL: imageURL,
                tags: "Tags: \(icon.tags.prefix(10).joined(separator: ", "))" ,
                sizeLabel: "\(icon.sizes.last?.width)x\(icon.sizes.last?.height)"
            )
        }
        
        let model: ModuleIconSearcherView.Model = .init(items: items)
        DispatchQueue.main.async {
            self.view?.update(model: model)
        }
    }
}
