//
//  TopFitnessLeaderboardCell.swift
//  StepTrackerCompetition
//
//  Created by Alexander Korte on 1/16/19.
//  Copyright © 2019 Alexander Korte. All rights reserved.
//

import UIKit

class TopFitnessLeaderboardCell: UITableViewCell {

    @IBOutlet weak var leaderboardTopFrame: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureLeaderboardTopFrame()
    }
    
    func configureLeaderboardTopFrame() {
        leaderboardTopFrame.layer.cornerRadius = 15
        leaderboardTopFrame.layer.masksToBounds = true
        leaderboardTopFrame.layer.borderWidth = 5
        leaderboardTopFrame.layer.borderColor = UIColor.mainPink.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
