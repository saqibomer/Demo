//
//  GamesViewModel.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import Foundation

final class GamesViewModel {
    // Outputs
    var isRefreshing: ((Bool) -> Void)?
    var didSelecteGame: ((Int) -> Void)?
    var didFetchGames: (([Results]) -> Void)?
    
    private(set) var games: [Results] = [Results]() {
        didSet {
            didFetchGames?(self.games)
        }
    }
    private var currentSearchNetworkTask: URLSessionDataTask?
    private var lastQuery: String?
    private var currentPage = 1
    private var pageSize = 10
    // Dependencies
    private let networkingService: NetworkingService
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    // Inputs
    func ready() {
        isRefreshing?(true)
        
        networkingService.fetchGames(withQuery: "?page_size=\(pageSize)&page=\(currentPage)") { [weak self] games in
            guard let strongSelf  = self else { return }
            strongSelf.finishSearching(with: games?.results ?? [])
        }
    }
    
    func didChangeQuery(_ query: String) {
        guard query.count > 2,
              query != lastQuery else { return } // distinct until changed
        lastQuery = query
        
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        if games.isEmpty { return }
        guard let id = games[indexPath.row].id else {
            return
        }
        didSelecteGame?(id)
    }
    
    // Private
    private func startSearchWithQuery(_ query: String) {
        currentSearchNetworkTask?.cancel() // cancel previous pending request
        
        isRefreshing?(true)
        
        currentSearchNetworkTask = networkingService.fetchGames(withQuery: query) { [weak self] games in
            guard let strongSelf  = self else { return }
            strongSelf.finishSearching(with: games?.results ?? [])
        }
    }
    
    private func finishSearching(with games: [Results]) {
        isRefreshing?(false)
        self.games = games
    }
}
