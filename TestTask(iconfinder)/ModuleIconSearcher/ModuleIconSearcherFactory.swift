//
//  Factory.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

final class Builder {
    
    static func makeMainViewController() -> UIViewController {
        let mainView = MainViewController()
        let iconSearchService: IconSearchServiceProtocol = IconSearchService()
        let mainPresenter = MainPresenter(view: mainView, iconSearchService: iconSearchService)
        mainView.presenter = mainPresenter
        return mainView
    }
}
