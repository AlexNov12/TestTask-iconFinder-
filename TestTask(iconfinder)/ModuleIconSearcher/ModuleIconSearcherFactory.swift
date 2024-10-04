//
//  ModuleIconSearcherFactory.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

final class ModuleIconSearcherFactory {
    
    static func make() -> UIViewController {
        let iconSearchRequestBuilder = IconSearchRequestBuilder()
        let iconSearchService = IconSearchService(iconSearchRequestBuilder: iconSearchRequestBuilder)
        let debounceExecutor = CancellableExecutor()
        let presenter = ModuleIconSearcherPresenter(iconSearchService: iconSearchService, debounceExecutor: debounceExecutor)
        
        let vc = ModuleIconSearcherViewController(presenter: presenter)
        
        presenter.view = vc
        return vc
    }
}
