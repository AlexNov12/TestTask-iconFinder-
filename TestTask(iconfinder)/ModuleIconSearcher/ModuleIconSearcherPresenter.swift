//
//  ModuleIconSearcherPresenter.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

protocol ModuleIconSearcherPresenterProtocol {
    func searchIcons(with text: String)
    func getIconCount() -> Int
    func getIcon(at index: Int) -> IconModel?
}

final class ModuleIconSearcherPresenter: ModuleIconSearcherPresenterProtocol {
    weak var view: ModuleIconSearcherViewProtocol?
    private let iconSearchService: IconSearchServiceProtocol!
    private var icons: [IconModel] = []
    
    required init(view: ModuleIconSearcherViewProtocol, iconSearchService: IconSearchServiceProtocol) {
        self.view = view
        self.iconSearchService = iconSearchService
    }
    
    func searchIcons(with text: String) {
        iconSearchService.searchIcons(query: text) { [weak self] icons, error in
            if let error = error {
                print("Error fetching icons: \(error)")
                return
            }
            self?.icons = icons ?? []
            self?.view?.update(model: IconModel)
        }
    }
    
    func getIconCount() -> Int {
        return icons.count
    }
    
    func getIcon(at index: Int) -> IconModel? {
        guard index < icons.count else { return nil }
        return icons[index]
    }
}
