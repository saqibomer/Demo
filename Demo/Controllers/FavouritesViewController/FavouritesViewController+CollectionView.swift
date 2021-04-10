//
//  FavouritesViewController+TableView.swift
//  Demo
//
//  Created by TOxIC on 10/04/2021.
//

import Foundation
import UIKit


extension FavouritesViewController {
    func removeFromFavourite(withId id: Int) {
        
        let aVc = UIAlertController(title: "Confirm", message: "Are you sure you want to remove this game from favourites", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            self.viewModel.removeFavoriteGames(id: id)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in
            
        }
        aVc.addAction(confirmAction)
        aVc.addAction(cancelAction)
        
        self.present(aVc, animated: true, completion: nil)
        
    }
}

extension FavouritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favouriteGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: GameCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
        cell.setupSwipteGesture()
        cell.gameTitleLabel.text = viewModel.favouriteGames[indexPath.item].name
        cell.metaCriticsLabel.text = "\(viewModel.favouriteGames[indexPath.item].metacritic ?? 0)"
        if let url: URL = URL(string: viewModel.favouriteGames[indexPath.item].backgroundImage ?? "") {
            cell.gameImageView.loadImageWithUrl(url)
        }
        
        
        
        if let genres = viewModel.favouriteGames[indexPath.item].genres {
            cell.genreLabel.text = genres.map { ($0.name ?? "") }.joined(separator: ", ")
        }
        cell.deleteBtn.tag = indexPath.item
        cell.deleteCellDelegate = self
        return cell
        
    }
    
    
}

extension FavouritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = viewModel.favouriteGames[indexPath.item].id else {
            return
        }
        viewModel.didSelectFavorite(withId: id)
    }
    
    
}

extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
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

extension FavouritesViewController: DeleteCellDelegate {
    
    func deleteCell(_ sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        guard let id = viewModel.favouriteGames[indexPath.item].id else {
            return
        }
        self.removeFromFavourite(withId: id)
    }
}

