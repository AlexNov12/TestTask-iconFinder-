//
//  MainViewController.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

class MainViewController: UIViewController, MainViewProtocol {
        
    var presenter: ModuleIconSearcherPresenterProtocol!
    private lazy var customView = self.view as? MainView
    
    override func loadView() {
        view = MainView(frame: .zero,
                        tableViewDelegate: self,
                        tableViewDataSource: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView?.getTableView().register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.reuseID)
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customView?.reloadDataTableView()
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    // MARK: - MainViewProtocol
    
    func reloadData() {
        DispatchQueue.main.async {
            self.customView?.reloadDataTableView()
        }
    }
    
    private func configureCell(_ cell: ImageTableViewCell, with icon: IconModel) {
        cell.configure(icon: icon)
        if let rasterSize = icon.raster_sizes.last {
            cell.sizeLabel.text = "\(rasterSize.size_width)x\(rasterSize.size_height)"
            cell.tagsLabel.text = "Tags: \(icon.tags.prefix(10).joined(separator: ", "))"
        } else {
            cell.sizeLabel.text = "No format available"
            cell.tagsLabel.text = "No tags available"
        }
    }
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchIcons(with: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchIcons(with: "")
    }
}

// MARK: UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getIconCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.reuseID, for: indexPath) as? ImageTableViewCell,
              let icon = presenter.getIcon(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        configureCell(cell, with: icon)
        return cell
    }
}

// MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = (tableView.frame.width - 32) / 3
        let height = width * 3
        return height
    }
}
