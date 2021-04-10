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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let viewModel = GamesViewModel(networkingService: NetworkClient())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        self.searchBar.delegate = self
        self.loadingIndicator.isHidden = true
        
        setupViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.text = ""
        viewModel.getViewedGames()
        
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
        
        viewModel.didUpdateViewedGames = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.ready()
        }
        
        viewModel.isRefreshing = { loading in
            
            if loading {
                self.loadingIndicator.isHidden = false
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.isHidden = true
                self.loadingIndicator.stopAnimating()
            }
            
        }
        
        viewModel.didFetchGames = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.gamesCollectionView.reloadData()
        }
        
        viewModel.didSelecteGame = { [weak self] id in
            guard let strongSelf = self else { return }
            let detailsVc = self?.storyboard?.instantiateViewController(withIdentifier: "GameDetailViewController") as! GameDetailViewController
            detailsVc.gameId = id
            strongSelf.navigationController?.pushViewController(detailsVc, animated: true)
            
        }
    }
    
}

extension GamesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell: GameCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
        //        @IBOutlet weak var containerView: UIView!
        cell.gameTitleLabel.text = viewModel.games[indexPath.item].name
        cell.metaCriticsLabel.text = "\(viewModel.games[indexPath.item].metacritic ?? 0)"
        if let url: URL = URL(string: viewModel.games[indexPath.item].backgroundImage ?? "") {
            cell.gameImageView.loadImageWithUrl(url)
        }
        
        
        
        if let genres = viewModel.games[indexPath.item].genres {
            cell.genreLabel.text = genres.map { ($0.name ?? "") }.joined(separator: ", ")
        }
        
        if let id = viewModel.games[indexPath.item].id  {
            if viewModel.viewedGames.contains(id) {
                cell.containerView.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
            } else {
                cell.containerView.backgroundColor = .white
            }
         
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
        viewModel.searchGames(searchBar.text ?? "")
        
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.searchGames("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
}
