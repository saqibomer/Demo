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
    var isDeviceLandscape = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        searchBar.delegate = self
        loadingIndicator.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        if UIDevice.current.orientation.isPortrait {
            isDeviceLandscape = false
        } else {
            isDeviceLandscape = true
        }
        setupViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.getViewedGames()
        
    }
    
    @objc func orientationDidChange() {
        if UIDevice.current.orientation.isPortrait {
            isDeviceLandscape = false
        } else {
            isDeviceLandscape = true
        }
        gamesCollectionView.reloadData()
    }
    
    private func setupViewModel() {
        
        viewModel.didUpdateViewedGames = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.startFetchingGames()
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
        
        viewModel.didChangeSearchQuery = {
            DispatchQueue.main.async {
                self.gamesCollectionView.setContentOffset(.zero, animated: true)
                self.gamesCollectionView.reloadData()
                
            }
            
        }
    }
    
}
