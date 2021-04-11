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
    var isDeviceLandscape = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        
        if UIDevice.current.orientation.isPortrait {
            isDeviceLandscape = false
        } else {
            isDeviceLandscape = true
        }
        
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.notFoundLabel.isHidden = true
        viewModel.getFavoriteGames()
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

