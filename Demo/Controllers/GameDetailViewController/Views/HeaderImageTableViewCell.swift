//
//  HeaderImageTableViewCell.swift
//  Demo
//
//  Created by TOxIC on 09/04/2021.
//

import UIKit

class HeaderImageTableViewCell: UITableViewCell {

    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameImageView: ImageLoader!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.gameImageView.contentMode = .scaleAspectFill
        self.gameImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
