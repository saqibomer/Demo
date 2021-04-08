//
//  FavouritesViewController.swift
//  Demo
//
//  Created by TOxIC on 09/04/2021.
//

import UIKit

class FavouritesViewController: UIViewController {

    @IBOutlet weak var gamesCollectionView: UICollectionView!
    
    let viewModel = GamesViewModel(networkingService: NetworkClient())
    private var data: [Results]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getFavoriteGames()
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
        
        
        
        viewModel.didUpdateFavourite = { [weak self] games in
            guard let strongSelf = self else { return }
            strongSelf.data = games
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

extension FavouritesViewController: UICollectionViewDataSource {
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

extension FavouritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = data?[indexPath.item].id else {
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
