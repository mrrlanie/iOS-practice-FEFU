//
//  ActivityCellViewTableViewCell.swift
//  fefuactivity
//
//  Created by students on 25.05.2022.
//

import UIKit

class ActivityCell: UITableViewCell {
    
    @IBOutlet var activityKM: UILabel!
    @IBOutlet var activityDT: UILabel!
    @IBOutlet var activityNM: UILabel!
    @IBOutlet var activityLT: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

