//
//  ModuleIconSearcherFactory.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

final class ModuleIconSearcherFactory {

    func make() -> UIViewController {
        let iconSearchRequestBuilder = IconSearchRequestBuilder()
        let networkService = NetworkService(iconSearchRequestBuilder: iconSearchRequestBuilder)
        let debounceExecutor = CancellableExecutor()
        let iconSearchService = IconSearchService(networkService: networkService, debounceExecutor: debounceExecutor)
        let presenter = ModuleIconSearcherPresenter(service: iconSearchService)

        let viewController = ModuleIconSearcherViewController(presenter: presenter)

        presenter.view = viewController
        return viewController
    }
}
