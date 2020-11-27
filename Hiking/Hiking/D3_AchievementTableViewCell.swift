//
//  D3_AchievementTableViewCell.swift
//  Hiking
//
//  Created by Paul Yim on 27/11/2020.
//

import UIKit

class D3_AchievementTableViewCell: UITableViewCell {

    @IBOutlet weak var totaldistance: UILabel!
    @IBOutlet weak var Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
