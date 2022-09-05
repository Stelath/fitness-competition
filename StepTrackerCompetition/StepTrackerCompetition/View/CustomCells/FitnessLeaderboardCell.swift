//
//  FitnessLeaderboardCell.swift
//  StepTrackerCompetition
//
//  Created by Alexander Korte on 1/18/19.
//  Copyright © 2019 Alexander Korte. All rights reserved.
//

import UIKit

class FitnessLeaderboardCell: UITableViewCell {

    @IBOutlet weak var cellOutline: UIView!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var stepCount: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCellOutline()
        configureImageView()
    }
    
    func configureCellOutline() {
        cellOutline.layer.borderWidth = 5
        cellOutline.layer.borderColor = UIColor.mainPink.cgColor
    }
    
    func configureImageView() {
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
