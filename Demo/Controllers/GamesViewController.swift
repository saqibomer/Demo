//
//  GamesViewController.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import UIKit

class GamesViewController: UIViewController {
    
    // Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gamesCollectionView: UICollectionView!
    
    let viewModel = GamesViewModel(networkingService: NetworkClient())
    private var data: [Results]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.ready()
        
    }
    
    private func setupViewModel() {
        viewModel.isRefreshing = { loading in
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }
        
        viewModel.didFetchGames = { [weak self] games in
            guard let strongSelf = self else { return }
            strongSelf.data = games
            print(games.first)
        }
        
        viewModel.didSelecteGame = { [weak self] id in
            guard let strongSelf = self else { return }
            let alertController = UIAlertController(title: "\(id)", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            strongSelf.present(alertController, animated: true, completion: nil)
        }
    }
    
}

extension GamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = data else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].name
        return cell
    }
}

extension GamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}

extension GamesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.didChangeQuery(searchController.searchBar.text ?? "")
    }
}
