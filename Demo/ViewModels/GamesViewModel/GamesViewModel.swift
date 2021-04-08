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
    var didFetchGameDetails: ((Results) -> Void)?
    var didUpdateFavourite: (([Results]) -> Void)?
    var didUpdateViewedGames: (([Int]) -> Void)?
    
    
    private(set) var games: [Results] = [Results]() {
        didSet {
            didFetchGames?(self.games)
        }
    }
    
    
    /*
     MARK: fetchedGames to retain fetched results when user cancells search fetchedGames will be used
     */
    private(set) var fetchedGames: [Results] = [Results]()
    
    
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
            strongSelf.fetchedGames = games?.results ?? []
            strongSelf.finishFetching(with: games?.results ?? [])
        }
    }
    
    
    func didSelectRow(at indexPath: IndexPath) {
        if games.isEmpty { return }
        guard let id = games[indexPath.row].id else {
            return
        }
        didSelecteGame?(id)
    }
    
    func searchGames(_ searchString: String) {
        isRefreshing?(true)
        if searchString != "" && searchString.count > 3 {
            startSearchWithQuery(searchString)
            
        } else {
            isRefreshing?(false)
            didFetchGames?(self.fetchedGames)
        }
        
    }
    
    func fetchGameDetails(_ id: Int) {
        isRefreshing?(true)
        currentSearchNetworkTask = networkingService.fetchGameDetails(withId: id) { [weak self] details in
            guard let strongSelf  = self else { return }
            strongSelf.isRefreshing?(false)
            guard let gameDetails  = details else { return }
            strongSelf.didFetchGameDetails?(gameDetails)
        }
        
    }
    /*
     Favorite Utillity functions
     */
    func getFavoriteGames() {
        
        if let savedGames = UserDefaults.standard.object(forKey: UserDefaultsKeys.favorite) as? Data {
            let decoder = JSONDecoder()
            if let favorites = try? decoder.decode([Results].self, from: savedGames) {
                self.didUpdateFavourite?(favorites)
            } else {
                self.didUpdateFavourite?([])
            }
        } else {
            self.didUpdateFavourite?([])
        }
        
    }
    
    func addToFavoriteGames(game: Results) {
        
        if let savedGames = UserDefaults.standard.object(forKey: UserDefaultsKeys.favorite) as? Data {
            let decoder = JSONDecoder()
            if var favorites = try? decoder.decode([Results].self, from: savedGames) {
                let alreadyExists = favorites.filter({$0.id == game.id})
                if alreadyExists.count <= 0 {
                    favorites.append(game)
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(favorites) {
                        UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.favorite)
                        self.didUpdateFavourite?(favorites)
                    }
                }
            } else {
                self.didUpdateFavourite?([])
            }
        } else {
            let encoder = JSONEncoder()
            let favorites = [game]
            if let encoded = try? encoder.encode(favorites) {
                UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.favorite)
                self.didUpdateFavourite?(favorites)
            } else {
                self.didUpdateFavourite?([])
            }
            
        }
       
        
        
    }
    
    func removeFavoriteGames(id: Int) {
        
        if let savedGames = UserDefaults.standard.object(forKey: UserDefaultsKeys.favorite) as? Data {
            let decoder = JSONDecoder()
            if let favorites = try? decoder.decode([Results].self, from: savedGames) {
                let filtered = favorites.filter({$0.id != id})
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(filtered) {
                    UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.favorite)
                    self.didUpdateFavourite?(filtered)
                }
            }
        }
        
        
    }
    
    /*
     Viewed Utillity functions
     */
    func getViewedGames() {
        
        guard let viewed = UserDefaults.standard.array(forKey: UserDefaultsKeys.viewed) as? [Int] else {
            self.didUpdateViewedGames?([])
            return
        }
        self.didUpdateViewedGames?(viewed)
        
    }
    
    func addToViewedGames(id: Int) {
        
        guard var viewed = UserDefaults.standard.array(forKey: UserDefaultsKeys.viewed) as? [Int] else {
            let items = [id]
            UserDefaults.standard.setValue(items, forKey: UserDefaultsKeys.viewed)
            self.didUpdateViewedGames?(items)
            return
        }
        if !viewed.contains(id) {
            viewed.append(id)
            self.didUpdateViewedGames?(viewed)
            UserDefaults.standard.setValue(viewed, forKey: UserDefaultsKeys.viewed)
        }
        
    }
    
    // Private
    private func startSearchWithQuery(_ query: String) {
        currentSearchNetworkTask?.cancel() // cancel previous pending request
        
        isRefreshing?(true)
        
        
        currentSearchNetworkTask = networkingService.fetchGames(withQuery: "?page_size=\(pageSize)&page=\(currentPage)&search=\(query)") { [weak self] games in
            guard let strongSelf  = self else { return }
            strongSelf.finishFetching(with: games?.results ?? [])
        }
    }
    
    private func finishFetching(with games: [Results]) {
        isRefreshing?(false)
        self.games = games
    }
    
    
    
    
}
