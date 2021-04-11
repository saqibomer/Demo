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
    var didFetchGames: (() -> Void)?
    var didFetchGameDetails: ((Results) -> Void)?
    var didUpdateFavourite: (() -> Void)?
    var didUpdateViewedGames: (() -> Void)?
    var didChangeSearchQuery: (() -> Void)?
    
    
    private(set) var games: [Results] = [Results]() {
        didSet {
            didFetchGames?()
        }
    }
    
    private(set) var searchResults: [Results] = [Results]() {
        didSet {
            didFetchGames?()
        }
    }
    
    private(set) var viewedGames: [Int] = []
    private(set) var favouriteGames: [Results] = []
    
    var isLoadingMore = false
    var isSearchActive = false
    var currentQuery = ""
    
    /**
     `fetchedGames` retain fetched results when user cancells search, fetchedGames will be used

     */
    
    private(set) var fetchedGames: [Results] = [Results]()
    
    
    private var currentSearchNetworkTask: URLSessionDataTask?
    private var lastQuery: String?
    var currentPage = 1
    private var pageSize = 10
    // Dependencies
    private let networkingService: NetworkingService
    
    /**
     Initializes `GamesViewModel`

     - Parameter networkingService: Network client
     */
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    /**
        The `startFetchingGames` method of the `GamesViewModel` object.

        Fetches games from api:

        ~~~
        // GamesViewModel:
        let games = gamesViewModel.startFetchingGames()
        ~~~
    */
    func startFetchingGames() {
        isRefreshing?(true)
        self.isSearchActive = false
        networkingService.fetchGames(withQuery: "?page_size=\(pageSize)&page=\(currentPage)") { [weak self] games in
            guard let strongSelf  = self else { return }
            if strongSelf.games.count > 0 {
                guard let results = games?.results else {
                    return
                }
                let updatedGames = strongSelf.games + results
                strongSelf.finishFetching(with: updatedGames)
                strongSelf.isLoadingMore = false
            } else {
                strongSelf.fetchedGames = games?.results ?? []
                strongSelf.finishFetching(with: games?.results ?? [])
            }
            
        }
    }
    
    /**
        The `didSelectRow` method of the `GamesViewModel` object.

        triggers `didSelecteGame` completion handler
        - Parameter at:  IndexPath of row or item selected
        ~~~
        // gamesViewModel:
        gamesViewModel.didSelectRow(at: indexPath)
        ~~~
    */
    
    func didSelectRow(at indexPath: IndexPath) {
        if games.isEmpty { return }
        guard let id = games[indexPath.row].id else {
            return
        }
        didSelecteGame?(id)
    }
    /**
        The `didSelectFavorite` method of the `GamesViewModel` object.

        triggers `didSelecteGame` completion handler
        - Parameter id:  id of row or item selected
        ~~~
        // gamesViewModel:
        gamesViewModel.didSelectFavorite(id: Int)
        ~~~
    */
    func didSelectFavorite(withId id: Int) {
        
        didSelecteGame?(id)
    }
    /**
        The `searchGames` method of the `GamesViewModel` object.

        sets state for pagination and calls `startSearchWithQuery` method
        - Parameter searchString:  search string, shouldReset: Bolean to clear previous current page
        ~~~
        // gamesViewModel:
        gamesViewModel.searchGames(searchString: String, shouldReset: Bool)
        ~~~
    */
    func searchGames(_ searchString: String, shouldReset: Bool) {
        
        if searchString != "" && searchString.count > 3 {
            self.isSearchActive = true
            currentQuery = searchString
            if shouldReset {
                resetCurrentPage()
            }
            
            startSearchWithQuery(searchString, shouldReset: shouldReset)
            
        }
        
    }
    /**
        The `finishSearching` method of the `GamesViewModel` object.

        clears state for pagination and reset `games` to  `fetchedGames`
        ~~~
        // gamesViewModel:
        gamesViewModel.finishSearching()
        ~~~
    */
    func finishSearching() {
        
        isRefreshing?(false)
        isSearchActive = false
        resetCurrentPage()
        isLoadingMore = false
        games = fetchedGames
    }
    /**
        The `fetchGameDetails` method of the `GamesViewModel` object.

        triggers `didFetchGameDetails` completion handler
        - Parameter id:  id of game
        ~~~
        // gamesViewModel:
        gamesViewModel.searchGames(searchString: String, shouldReset: Bool)
        ~~~
    */
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
                self.favouriteGames = favorites
                self.didUpdateFavourite?()
            } else {
                self.didUpdateFavourite?()
            }
        } else {
            self.didUpdateFavourite?()
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
                        self.favouriteGames = favorites
                        self.didUpdateFavourite?()
                    }
                }
            } else {
                self.didUpdateFavourite?()
            }
        } else {
            let encoder = JSONEncoder()
            let favorites = [game]
            if let encoded = try? encoder.encode(favorites) {
                UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.favorite)
                self.favouriteGames = favorites
                self.didUpdateFavourite?()
                
            } else {
                self.didUpdateFavourite?()
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
                    self.favouriteGames = filtered
                    self.didUpdateFavourite?()
                }
            }
        }
        
        
    }
    
    /*
     Viewed Utillity functions
     */
    func getViewedGames() {
        
        guard let viewed = UserDefaults.standard.array(forKey: UserDefaultsKeys.viewed) as? [Int] else {
            self.didUpdateViewedGames?()
            return
        }
        self.viewedGames = viewed
        self.didUpdateViewedGames?()
        
    }
    
    func addToViewedGames(id: Int) {
        
        guard var viewed = UserDefaults.standard.array(forKey: UserDefaultsKeys.viewed) as? [Int] else {
            let items = [id]
            UserDefaults.standard.setValue(items, forKey: UserDefaultsKeys.viewed)
            self.viewedGames = items
            self.didUpdateViewedGames?()
            return
        }
        if !viewed.contains(id) {
            viewed.append(id)
            self.viewedGames = viewed
            self.didUpdateViewedGames?()
            UserDefaults.standard.setValue(viewed, forKey: UserDefaultsKeys.viewed)
        }
        
    }
    
    // Private
    private func startSearchWithQuery(_ query: String, shouldReset: Bool) {
        currentSearchNetworkTask?.cancel() // cancel previous pending request
        
        isRefreshing?(true)
        currentSearchNetworkTask = networkingService.fetchGames(withQuery: "?page_size=\(pageSize)&page=\(currentPage)&search=\(query)") { [weak self] games in
            guard let strongSelf  = self else { return }
            if shouldReset {
                strongSelf.didChangeSearchQuery?()
                strongSelf.finishFetching(with: games?.results ?? [])
                
                
            } else {
                guard let results = games?.results else {
                    return
                }
                let updatedGames = strongSelf.searchResults + results
                strongSelf.finishFetching(with: updatedGames)
                strongSelf.isLoadingMore = false
            }
            
        }
    }
    
    private func finishFetching(with games: [Results]) {
        isRefreshing?(false)
        if self.isSearchActive {
            searchResults = games
        } else {
            self.games = games
        }
        
    }
    
    private func resetCurrentPage() {
        currentPage = 1
    }
    
    
    
    
}
