//
//  GameCollectionViewCell.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import UIKit

protocol DeleteCellDelegate {
    func deleteCell(_ sender : UIButton)
}

class GameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: SwipeView!
    @IBOutlet weak var gameImageView: ImageLoader!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var metaCriticsLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    var deleteCellDelegate: DeleteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.gameImageView.contentMode = .scaleAspectFill
        self.gameImageView.clipsToBounds = true
        
    }
    
    
    
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        deleteCellDelegate?.deleteCell(sender)
    }
    
    func setupSwipteGesture() {
        self.containerView.setupGesture()
        self.containerView.maxSwipe = self.bounds.width
    }
    
    
}
