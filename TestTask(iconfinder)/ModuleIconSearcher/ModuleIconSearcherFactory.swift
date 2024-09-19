//
//  ModuleIconSearcherFactory.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

final class ModuleIconSearcherFactory {
    
    static func make() -> UIViewController {
        let iconSearchService: IconSearchServiceProtocol = IconSearchService()
        let iconCacheManager: IconCacheManagerProtocol = IconCacheManager()
        let imageLoaderManager: ImageLoaderManagerProtocol = ImageLoaderManager(iconCacheManager: iconCacheManager)
        let presenter = ModuleIconSearcherPresenter(iconSearchService: iconSearchService, imageLoaderManager: imageLoaderManager)
        let viewController = ModuleIconSearcherViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}

