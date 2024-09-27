//
//  ModuleIconSearcherView.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

final class ModuleIconSearcherView: UIView {
    
    typealias Item = ModuleIconSearcherTableViewCell.Model
    
    struct Model {
        let items: [Item]
    }
    
    private var model: Model?
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(ModuleIconSearcherTableViewCell.self, forCellReuseIdentifier: ModuleIconSearcherTableViewCell.iconCell)
        view.separatorInset = .zero
        view.tableFooterView = UIView()
        view.backgroundColor = .systemBackground
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private let presenter: ModuleIconSearcherPresenterProtocol
    
    init(presenter: ModuleIconSearcherPresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        self.model = model
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension ModuleIconSearcherView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model, let cell = tableView.dequeueReusableCell(withIdentifier: ModuleIconSearcherTableViewCell.iconCell) as?
                ModuleIconSearcherTableViewCell else {
                return UITableViewCell()
        }
        
        let item = model.items[indexPath.row]
        
        let cellModel = ModuleIconSearcherTableViewCell.Model(
            imageURL: item.imageURL,
            tags: item.tags,
            sizeLabel: item.sizeLabel
        )
        
        cell.update(with: cellModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ModuleIconSearcherView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension ModuleIconSearcherView {
    
    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
