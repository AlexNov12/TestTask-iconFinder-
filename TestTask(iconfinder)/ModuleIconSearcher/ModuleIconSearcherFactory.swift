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
        let debounceExecutor: CancellableExecutorProtocol = CancellableExecutor()
        let permissionAlert: PermissionAlertControllerProtocol = PermissionAlertController()
        let successAlert: SuccessAlertControllerProtocol = SuccessAlertController()
        let iconSavingManager: IconSavingManagerProtocol = IconSavingManager(permissionAlert: permissionAlert, successAlert: successAlert)
        let presenter = ModuleIconSearcherPresenter(
            iconSearchService: iconSearchService,
            imageLoaderManager: imageLoaderManager,
            debounceExecutor: debounceExecutor,
            iconSavingManager: iconSavingManager
        )
        
        let vc = ModuleIconSearcherViewController(presenter: presenter)
        
        presenter.view = vc
        return vc
    }
}
