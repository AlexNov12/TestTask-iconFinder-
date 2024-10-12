//
//  ModuleIconSearcherPresenter.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import Foundation
import UIKit

protocol ModuleIconSearcherPresenterProtocol {

    func request(query: String)
    func requestNext()
    func requestClearSearch()

    func viewDidLoad()
    func retryLoading()
}

final class ModuleIconSearcherPresenter: ModuleIconSearcherPresenterProtocol {

    weak var view: ModuleIconSearcherViewProtocol?
    private let service: IconSearchServiceProtocol

    private var isRequestProcessing = false

    private var icons = [IconResponse.IconModel]()

    required init(service: IconSearchServiceProtocol) {
        self.service = service
    }

    func viewDidLoad() {
        updateViewWithEmpty()
    }

    func request(query: String) {
        guard !query.isEmpty else {
            requestClearSearch()
            return
        }
        processBeforeRequest()
        service.requestIcon(query: query) { [weak self] response in
            self?.processServiceResponse(response: response)
        }
    }

    func requestNext() {
        guard !isRequestProcessing else { return }

        processBeforeRequest(isShowLoading: false)

        service.requestNext { [weak self] response in
            self?.processServiceResponse(response: response)
        }
    }

    func requestClearSearch() {
        icons.removeAll()
        service.resetSeatch()
        updateViewWithEmpty()
    }

    func retryLoading() {
        requestNext()
    }
}

private extension ModuleIconSearcherPresenter {

    func processServiceResponse(response: Result<[IconResponse.IconModel], Error>) {
        guard case let .success(model) = response else {
            self.isRequestProcessing = false
            self.view?.showError()
            return
        }

        let items: [ModuleIconSearcherCollectionViewCell.Model] = model.compactMap { (item: IconResponse.IconModel) in
            let imageURL = item.sizes.last?.formats.last?.previewURL ?? ""
            let tags = "Tags: \(item.tags.prefix(10).joined(separator: ", "))"
            let sizeLabel: String
            if let width = item.sizes.last?.width, let height = item.sizes.last?.height {
                sizeLabel = "\(width)x\(height)"
            } else {
                sizeLabel  = "No format available"
            }

            return ModuleIconSearcherCollectionViewCell.Model(
                imageURL: imageURL,
                tags: tags,
                sizeLabel: sizeLabel
            )
        }

        icons = model
        isRequestProcessing = false

        self.view?.hideLoading()
        self.updateView(items: items)
    }

    func updateView(items: [ModuleIconSearcherCollectionViewCell.Model]) {

        guard !items.isEmpty else {
            view?.showEmpty(for: .emptySearchState)
            return
        }

        let model = makeIconsCollectionModel(items: items)

        view?.update(model: model)
    }

    func updateViewWithEmpty() {
        let model = makeIconsCollectionModel(items: [])

        view?.update(model: model)
        view?.showEmpty(for: .emptyState)
    }

    func makeIconsCollectionModel(items: [ModuleIconSearcherCollectionViewCell.Model]) -> ModuleIconSearcherView.Model {
        let model = ModuleIconSearcherView.Model(
            items: items,
            onRequestData: { [weak self] index in
                self?.processDataRequest(index: index)
            }
        )
        return model
    }

    func processDataRequest(index: Int) {
        guard index >= icons.count - 1 else { return }
        requestNext()
    }

    func processBeforeRequest(isShowLoading: Bool = true) {
        isRequestProcessing = true
        if isShowLoading {
            view?.showLoading()
        }
    }
}
