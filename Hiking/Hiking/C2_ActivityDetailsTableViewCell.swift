//
//  C2_ActivityDetailsTableViewCell.swift
//  Hiking
//
//  Created by Will Lam on 23/11/2020.
//

import UIKit

class C2_ActivityDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var routeImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
