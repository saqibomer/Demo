//
//  GameCollectionViewCell.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gameImageView: ImageLoader!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var metaCriticsLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.gameImageView.contentMode = .scaleAspectFill
        self.gameImageView.clipsToBounds = true
    }

}
