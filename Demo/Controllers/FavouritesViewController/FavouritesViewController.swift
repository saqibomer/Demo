//
//  FavouritesViewController.swift
//  Demo
//
//  Created by TOxIC on 09/04/2021.
//

import UIKit

class FavouritesViewController: UIViewController {

    @IBOutlet weak var notFoundLabel: UILabel!
    @IBOutlet weak var gamesCollectionView: UICollectionView!
    
    let viewModel = GamesViewModel(networkingService: NetworkClient())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.notFoundLabel.isHidden = true
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
        
        viewModel.didUpdateFavourite = { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.viewModel.favouriteGames.count > 0 {
                strongSelf.notFoundLabel.isHidden = true
            } else {
                strongSelf.notFoundLabel.isHidden = false
            }
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

