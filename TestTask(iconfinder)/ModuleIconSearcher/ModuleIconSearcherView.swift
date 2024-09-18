//
//  MainView.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

class MainView: UIView {
    
    private let tableView: UITableView
    
    init(frame: CGRect, tableViewDelegate: UITableViewDelegate, tableViewDataSource: UITableViewDataSource) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(frame: frame)
        setupView(tableViewDelegate: tableViewDelegate, tableViewDataSource: tableViewDataSource)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(tableViewDelegate: UITableViewDelegate, tableViewDataSource: UITableViewDataSource) {
        addSubview(tableView)
        backgroundColor = .white
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDataSource
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func reloadDataTableView() {
        tableView.reloadData()
    }
    
    func getTableView() -> UITableView {
        return tableView
    }
}
