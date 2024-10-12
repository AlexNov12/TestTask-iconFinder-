//
//  IconSearchService.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 11.10.2024.
//

import Foundation

protocol IconSearchServiceProtocol {

    func requestIcon(query: String, completion: @escaping (Result<[IconResponse.IconModel], Error>) -> Void)
    func requestNext(completion: @escaping (Result<[IconResponse.IconModel], Error>) -> Void)
    func resetSeatch()
}

final class IconSearchService: IconSearchServiceProtocol {
    private let networkService: IconsSearchNetworkServiceProtocol
    private let debounceExecutor: CancellableExecutorProtocol

    private var icons = [IconResponse.IconModel]()
    private var query = ""
    private var offset = 0
    private var totalCount = 0

    init(networkService: IconsSearchNetworkServiceProtocol, debounceExecutor: CancellableExecutorProtocol) {
        self.networkService = networkService
        self.debounceExecutor = debounceExecutor
    }

    func requestIcon(query: String, completion: @escaping (Result<[IconResponse.IconModel], Error>) -> Void) {
        self.query = query
        reset()
        execute(query: query, offset: offset, itemsPerPage: Constants.iconsCount, completion: completion)
    }

    func requestNext(completion: @escaping (Result<[IconResponse.IconModel], Error>) -> Void) {
        guard offset + Constants.iconsCount < totalCount else {
            return
        }
        offset += Constants.iconsCount
        execute(query: query, offset: offset, itemsPerPage: Constants.iconsCount, completion: completion)
    }

    func resetSeatch() {
        self.query = ""
        debounceExecutor.cancel()
        reset()
    }
}

private extension IconSearchService {
    func execute(
        query: String,
        offset: Int,
        itemsPerPage: Int,
        completion: @escaping (Result<[IconResponse.IconModel], Error>) -> Void
    ) {
        debounceExecutor.cancel()
        debounceExecutor.execute(delay: Constants.executeDelay) { [weak self] cancellable in

            if cancellable.isCancelled { return }

            self?.networkService.requestIcons(
                query: query,
                count: itemsPerPage,
                offset: offset
            ) { [weak self] response in
                if cancellable.isCancelled { return }
                guard let self else { return }
                switch response {
                case let .success(searchModel):
                    self.totalCount = searchModel.totalCount
                    self.icons.append(contentsOf: searchModel.icons)
                    completion(.success(self.icons))
                case let .failure(error):
                        completion(.failure(error))
                }
            }
        }
    }

    func reset() {
        offset = 0
        totalCount = 0
        icons.removeAll()
    }
}

private extension IconSearchService {
    enum Constants {
        static let iconsCount = 20
        static let executeDelay = DispatchTimeInterval.milliseconds(300)
    }
}
