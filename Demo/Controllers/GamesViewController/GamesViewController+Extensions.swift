//
//  GamesViewController+Extensions.swift
//  Demo
//
//  Created by TOxIC on 10/04/2021.
//

import Foundation
import UIKit

extension GamesViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.gamesCollectionView.contentOffset.y >= (self.gamesCollectionView.contentSize.height - self.gamesCollectionView.bounds.size.height)) {
            if !viewModel.isLoadingMore {
                viewModel.isLoadingMore = true
                viewModel.currentPage = viewModel.currentPage + 1
                if viewModel.isSearchActive {
                    viewModel.searchGames(searchBar.text ?? "", shouldReset: false)
                } else {
                    viewModel.startFetchingGames()
                }
                
            }
        }
    }
}



extension GamesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.isSearchActive {
            return viewModel.searchResults.count
        }
        return viewModel.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var game: Results!
        if viewModel.isSearchActive {
            game = viewModel.searchResults[indexPath.item]
        } else {
            game = viewModel.games[indexPath.item]
        }
        let cell: GameCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
        
        cell.gameTitleLabel.text = game.name
        cell.metaCriticsLabel.text = "\(game.metacritic ?? 0)"
//        if let url: URL = URL(string: game.backgroundImage ?? "") {
//            cell.gameImageView.loadImageWithUrl(url)
//        }
        cell.gameImageView.image = UIImage(named: "gamesIcon")
        
        
        if let genres = game.genres {
            cell.genreLabel.text = genres.map { ($0.name ?? "") }.joined(separator: ", ")
        }
        
        if let id = game.id  {
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
        guard let searchQuery = searchBar.text else { return }
        viewModel.searchGames(searchQuery, shouldReset: true)
        
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        gamesCollectionView.setContentOffset(.zero, animated: true)
        viewModel.finishSearching()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    
}
