//
//  E1_CommunityTableViewCell.swift
//  Hiking
//
//  Created by Will Lam on 26/11/2020.
//

import UIKit

class E1_CommunityTableViewCell: UITableViewCell {

    @IBOutlet weak var lb_writer: UILabel!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_content: UILabel!
    @IBOutlet weak var lb_date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
