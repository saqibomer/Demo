//
//  DescriptionTableViewCell.swift
//  Demo
//
//  Created by TOxIC on 09/04/2021.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellDescptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
