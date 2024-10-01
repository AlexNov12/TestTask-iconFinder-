//
//  ModuleIconSearcherViewController.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

protocol ModuleIconSearcherViewProtocol: AnyObject {
    func update(model: ModuleIconSearcherView.Model)
    func showLoading()
    func hideLoading()
    func showError()
    func showEmpty(text: String)
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
        super.viewDidLoad()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
}

// MARK: UISearchBarDelegate

extension ModuleIconSearcherViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchIcons(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchIcons(with: "")
    }
}

extension ModuleIconSearcherViewController: ModuleIconSearcherViewProtocol {
    func update(model: ModuleIconSearcherView.Model) {
        customView.update(model: model)
    }
    func showLoading() {
        customView.showLoading()
    }
    
    func hideLoading() {
        customView.hideLoading()
    }
    
    func showError() {
        customView.showError()
    }
    
    func showEmpty(text: String) {
        customView.showEmpty(text: text)
    }
}
