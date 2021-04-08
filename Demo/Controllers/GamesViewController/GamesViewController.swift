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
        
//        gamesCollectionView.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: "GameCollectionViewCell")
        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        viewModel.ready()
        setupViewModel()
        
    }
    
    private func setupViewModel() {
        viewModel.isRefreshing = { loading in
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }
        
        viewModel.didFetchGames = { [weak self] games in
            guard let strongSelf = self else { return }
            strongSelf.data = games
            strongSelf.gamesCollectionView.reloadData()
        }
        
        viewModel.didSelecteGame = { [weak self] id in
            guard let strongSelf = self else { return }
            let alertController = UIAlertController(title: "\(id)", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            strongSelf.present(alertController, animated: true, completion: nil)
        }
    }
    
}

extension GamesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let data = data else { return UICollectionViewCell() }
        let cell: GameCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
//        @IBOutlet weak var containerView: UIView!
//        @IBOutlet weak var gameImageView: UIImageView!
//        @IBOutlet weak var gameTitleLabel: UILabel!
//        @IBOutlet weak var metaCriticsLabel: UILabel!
//        @IBOutlet weak var genreLabel: UILabel!
        cell.gameTitleLabel.text = data[indexPath.item].name
        if let url: URL = URL(string: data[indexPath.item].backgroundImage ?? "") {
            cell.gameImageView.loadImageWithUrl(url)
        }
        
//        cell.genreLabel.text  = data[indexPath.item].genres.names.map{String($0)}).joined(separator: ",")
        return cell
        
    }
    
    
}

extension GamesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
    
}

extension GamesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width - 20, height: 136)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

extension GamesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.didChangeQuery(searchController.searchBar.text ?? "")
    }
}
