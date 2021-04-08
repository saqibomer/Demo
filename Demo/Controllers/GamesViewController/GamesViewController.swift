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
        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        self.searchBar.delegate = self
        viewModel.ready()
        setupViewModel()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            if let layout = gamesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
        } else {
            if let layout = gamesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
            }
        }
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
        cell.gameTitleLabel.text = data[indexPath.item].name
        cell.metaCriticsLabel.text = "\(data[indexPath.item].metacritic ?? 0)"
        if let url: URL = URL(string: data[indexPath.item].backgroundImage ?? "") {
            cell.gameImageView.loadImageWithUrl(url)
        }
        
        
        
        if let genres = data[indexPath.item].genres {
            cell.genreLabel.text = genres.map { ($0.name ?? "") }.joined(separator: ", ")
        }
        
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
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .landscapeLeft {
            return CGSize(width: collectionView.frame.width / 2, height: 136)
        }
        return CGSize(width: collectionView.frame.width, height: 136)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

extension GamesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.filterGames("")
        } else {
            viewModel.filterGames(searchBar.text ?? "")
        }
        
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.filterGames("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
     }
    
    
}
