//
//  GameDetailViewController.swift
//  Demo
//
//  Created by TOxIC on 09/04/2021.
//

import UIKit
import SafariServices

class GameDetailViewController: UIViewController {
    
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let viewModel = GamesViewModel(networkingService: NetworkClient())
    private var gameDetail: Results?
    var gameId: Int!
    var favorites: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        detailsTableView.register(UINib(nibName: "HeaderImageTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderImageTableViewCell")
        detailsTableView.register(UINib(nibName: "SingleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "SingleLabelTableViewCell")
        detailsTableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
        loadingIndicator.isHidden = true
        viewModel.addToViewedGames(id: gameId)
        
        setupViewModel()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavoriteGames()
        viewModel.fetchGameDetails(gameId)
        
    }
    
    private func setupViewModel() {
        viewModel.isRefreshing = { loading in
            
            if loading {
                self.loadingIndicator.isHidden = false
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.isHidden = true
                self.loadingIndicator.stopAnimating()
            }
            
        }
        
        viewModel.didFetchGameDetails = { [weak self] details in
            guard let strongSelf = self else { return }
            strongSelf.gameDetail = details
            strongSelf.detailsTableView.reloadData()
        }
        
        viewModel.didUpdateFavourite = { [weak self] favorite in
            guard let strongSelf = self else { return }
            
            
            let filtered = favorite.filter({$0.id == strongSelf.gameId})
            if filtered.count > 0 {
                strongSelf.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorited", style: .plain, target: self, action: #selector(strongSelf.favouriteBtnAction))
            } else {
                strongSelf.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(strongSelf.favouriteBtnAction))
            }
        }
        
        
    }
    
    @objc func favouriteBtnAction(_ sender: UIBarButtonItem){
        
        switch sender.title {
        case "Favorite":
            guard let game = self.gameDetail else {
                return
            }
            viewModel.addToFavoriteGames(game: game)
        case "Favorited":
            removeFromFavourite()
            
        default:
            print("none")
        }
    }
    
    func removeFromFavourite() {
        
        let aVc = UIAlertController(title: "Confirm", message: "Are you sure you want to remove this game from favourites", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            self.viewModel.removeFavoriteGames(id: self.gameId)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in
            
        }
        aVc.addAction(confirmAction)
        aVc.addAction(cancelAction)
        
        self.present(aVc, animated: true, completion: nil)
        
    }
    
}

extension GameDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.gameDetail != nil else {
            return 0
        }
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = self.gameDetail else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            let cell: HeaderImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HeaderImageTableViewCell", for: indexPath) as! HeaderImageTableViewCell
            if let url: URL = URL(string: data.backgroundImage ?? "") {
                cell.gameImageView.loadImageWithUrl(url)
            }
            cell.gameTitleLabel.text = data.name
            return cell
        case 1:
            let cell: DescriptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            cell.cellDescptionLabel.text = data.description
            return cell
        case 2:
            let cell: SingleLabelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SingleLabelTableViewCell", for: indexPath) as! SingleLabelTableViewCell
            cell.cellTitleLabel.text = "Visit reddit"
            return cell
        case 3:
            let cell: SingleLabelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SingleLabelTableViewCell", for: indexPath) as! SingleLabelTableViewCell
            cell.cellTitleLabel.text = "Visit website"
            return cell
        default:
            return UITableViewCell()
        }
        
        
    }
    
    
    
    
    
}

extension GameDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 291
        case 1:
            return UITableView.automaticDimension
        default:
            return 54
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = self.gameDetail else { return }
        
        switch indexPath.row {
        case 2:
            if let url = URL(string: data.redditUrl ?? "") {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                
                let vc = SFSafariViewController(url: url, configuration: config)
                present(vc, animated: true)
            }
        case 3:
            if let url = URL(string: data.website ?? "") {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                
                let vc = SFSafariViewController(url: url, configuration: config)
                present(vc, animated: true)
            }
        default:
            print("none")
        }
    }
    
    
}
