//
//  ModuleIconSearcherViewController.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

protocol ModuleIconSearcherViewControllerProtocol: AnyObject {
    func update(model: ModuleIconSearcherView.Model)
}

final class ModuleIconSearcherViewController: UIViewController {
    
    private let presenter: ModuleIconSearcherPresenterProtocol
    private lazy var customView = ModuleIconSearcherView(presenter: presenter)
    
    init(presenter: ModuleIconSearcherPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        presenter.viewDidLoad()
    }
}

extension ModuleIconSearcherViewController: ModuleIconSearcherViewControllerProtocol {
    func update(model: ModuleIconSearcherView.Model) {
        customView.update(model: model)
    }
}
